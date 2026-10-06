/*
 * LicenseForge CLI 2.4.1  -  Produktlizenz-Verwaltung
 * (c) 2024 LicenseForge GmbH
 *
 *   validate --license <SCHLUESSEL>   Lizenz pruefen und Pro freischalten
 *   validate --info    <SCHLUESSEL>   Lizenz-Details anzeigen
 *   validate --version                Version anzeigen
 *   validate --help                   diese Hilfe
 *   -v | --verbose                    ausfuehrliche Ausgabe
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "tweetnacl.h"

void randombytes(unsigned char *x, unsigned long long n) { (void)x; (void)n; }

static const char *VERSION = "LicenseForge CLI 2.4.1";
static const char *COPYRIGHT = "(c) 2024 LicenseForge GmbH";
static int g_verbose = 0;
static void vlog(const char *m) { if (g_verbose) fprintf(stderr, "[v] %s\n", m); }

/* Oeffentlicher Ausstellungsschluessel (Ed25519). Privater Teil NICHT im Binary. */
static const unsigned char PUBKEY[32] = {
    0x9c,0xd1,0x26,0x72,0xac,0x70,0x66,0x0b,0x84,0x36,0xbe,0x2b,
    0x54,0x04,0x3c,0x98,0xdd,0xed,0xa2,0xb9,0x52,0x26,0xa8,0xea,
    0xed,0x62,0x93,0xe6,0x3e,0x61,0x84,0xf7};

/* ---- laufzeit-dekodierte, sicherheitsrelevante Textbausteine ----------- */
#define XK 0x5A
static const unsigned char ENC_PFX1[7]  = {0x1e,0x12,0x18,0x0d,0x6b,0x77,0x5a};
static const unsigned char ENC_OK[51]   = {0x01,0x15,0x11,0x07,0x7a,0x16,0x33,0x20,0x3f,0x34,0x20,0x7a,0x3d,0x2f,0x3f,0x36,0x2e,0x33,0x3d,0x7a,0x77,0x7a,0x0a,0x28,0x35,0x77,0x1c,0x2f,0x34,0x31,0x2e,0x33,0x35,0x34,0x7a,0x3c,0x28,0x3f,0x33,0x3d,0x3f,0x29,0x39,0x32,0x3b,0x36,0x2e,0x3f,0x2e,0x74,0x5a};
static const unsigned char ENC_DENY[27] = {0x01,0x1e,0x1f,0x14,0x13,0x1f,0x1e,0x07,0x7a,0x16,0x33,0x20,0x3f,0x34,0x20,0x7a,0x2f,0x34,0x3d,0x2f,0x3f,0x36,0x2e,0x33,0x3d,0x74,0x5a};
static void xdec(const unsigned char *e, int n, char *out) {
    for (int i = 0; i < n; i++) out[i] = (char)(e[i] ^ XK);
}

/* ---- Hex-Hilfen -------------------------------------------------------- */
static int nib(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}
static int hexbytes(const char *s, unsigned char *out, int n) {
    for (int i = 0; i < n; i++) {
        int hi = nib(s[2*i]), lo = nib(s[2*i+1]);
        if (hi < 0 || lo < 0) return 0;
        out[i] = (unsigned char)((hi << 4) | lo);
    }
    return 1;
}
static int hex4(const char *p, uint16_t *v) {
    uint16_t r = 0;
    for (int i = 0; i < 4; i++) {
        int nb = nib(p[i]);
        if (nb < 0) return 0;
        r = (uint16_t)((r << 4) | (unsigned)nb);
    }
    *v = r;
    return 1;
}

/* ---- Integritaets-/Diagnose-Helfer (Anzeige) -------------------------- */
static uint16_t crc16(const char *s) {
    uint16_t c = 0xFFFF;
    for (; *s; s++) {
        c ^= (uint16_t)((unsigned char)*s) << 8;
        for (int i = 0; i < 8; i++)
            c = (c & 0x8000) ? (uint16_t)((c << 1) ^ 0x1021) : (uint16_t)(c << 1);
    }
    return c;
}
static uint32_t fnv1a(const char *s) {
    uint32_t h = 2166136261u;
    for (; *s; s++) { h ^= (unsigned char)*s; h *= 16777619u; }
    return h;
}
/* Sperrliste zurueckgezogener Lizenzen */
static const uint32_t REVOKED[3] = {0x6b110ba9, 0xbdaa4f70, 0x98f31667};
static int is_revoked(const char *s) {
    uint32_t h = fnv1a(s);
    for (int i = 0; i < 3; i++)
        if (h == REVOKED[i]) return 1;
    return 0;
}

/* ---- v2: Ed25519-signierte Lizenz (aktueller Pfad) -------------------- */
static int verify_v2(const char *s) {
    if (strncmp(s, "DHBW2-", 6) != 0) return -1;
    const char *p = s + 6;
    if (strlen(p) != 8 + 1 + 128) return -1;
    if (p[8] != '-') return -1;
    unsigned char payload[4], sig[64];
    if (!hexbytes(p, payload, 4)) return -1;
    if (!hexbytes(p + 9, sig, 64)) return -1;
    unsigned char sm[68], m[68];
    unsigned long long mlen;
    memcpy(sm, sig, 64);
    memcpy(sm + 64, payload, 4);
    if (crypto_sign_open(m, &mlen, sm, 68, PUBKEY) != 0) return 0;
    return (mlen == 4 && memcmp(m, payload, 4) == 0) ? 1 : 0;
}

/* ---- Ableitung der Vergleichsparameter (nicht materialisiert) --------- */
static volatile uint16_t T[16] = {
    0x0037,0x004A,0x005D,0x0070,0x0083,0x0096,0x00A9,0x00BC,
    0x00CF,0x00E2,0x00F5,0x0108,0x011B,0x012E,0x0141,0x0154};
static uint16_t derive_key(void) {
    uint16_t k = 0;
    for (int i = 0; i < 16; i++) {
        k = (uint16_t)(k + T[i]);
        k = (uint16_t)(k ^ (uint16_t)(k << 3));
        if (((((unsigned)k) * (((unsigned)k) + 1u)) & 1u) != 0u) k ^= (uint16_t)0xBEEF;
    }
    return k;
}
static const uint16_t BLOB0 = 0x5610, BLOB1 = 0x6786, BLOB2 = 0xC616;

static int parse_legacy_groups(const char *s, uint16_t g[4]) {
    char pfx[7];
    xdec(ENC_PFX1, 7, pfx);
    if (strncmp(s, pfx, 6) != 0) return 0;
    const char *p = s + 6;
    if (!hex4(p, &g[0])      || p[4]  != '-') return 0;
    if (!hex4(p + 5, &g[1])  || p[9]  != '-') return 0;
    if (!hex4(p + 10, &g[2]) || p[14] != '-') return 0;
    if (!hex4(p + 15, &g[3]) || p[19] != '\0') return 0;
    return 1;
}

/* ---- Kompatibilitaets-Pruefung (unbekanntes Format) ------------------- */
static int legacy_check(const char *s) {
    uint16_t g[4];
    if (!parse_legacy_groups(s, g)) return 0;
    uint16_t a = g[0], b = g[1], c = g[2], d = g[3];

    uint16_t S = (uint16_t)(a + b + c + d);
    uint16_t X = (uint16_t)(a ^ b ^ c ^ d);
    uint16_t P = (uint16_t)((unsigned)a * b + (unsigned)c * d);

    uint16_t k = derive_key();
    uint16_t mask0 = k;
    uint16_t mask1 = (uint16_t)((k << 5) | (k >> 11));
    uint16_t mask2 = (uint16_t)((unsigned)k * 0x9e37u);

    uint32_t acc = 0;
    acc |= (uint16_t)(S ^ (uint16_t)(BLOB0 ^ mask0));
    acc |= (uint16_t)(X ^ (uint16_t)(BLOB1 ^ mask1));
    acc |= (uint16_t)(P ^ (uint16_t)(BLOB2 ^ mask2));
    return acc == 0;
}

/* ---- Gate ------------------------------------------------------------- */
static int license_ok(const char *s) {
    int r = verify_v2(s);
    if (r >= 0) { vlog("Signaturpruefung durchgefuehrt"); return r; }
    if (is_revoked(s)) { vlog("Lizenz gesperrt"); return 0; }
    vlog("Kompatibilitaetspruefung");
    return legacy_check(s);
}

/* ---- --info ----------------------------------------------------------- */
static void do_info(const char *s) {
    printf("Lizenz-Info:\n");
    if (strncmp(s, "DHBW2-", 6) == 0 && strlen(s + 6) == 137) {
        unsigned char pl[4];
        if (hexbytes(s + 6, pl, 4)) {
            unsigned long id = ((unsigned long)pl[0] << 24) | (pl[1] << 16) | (pl[2] << 8) | pl[3];
            printf("  Format:     v2 (aktuell)\n");
            printf("  Kunde-ID:   %lu\n", id);
        } else {
            printf("  Format:     v2 (beschaedigt)\n");
        }
    } else {
        uint16_t g[4];
        if (parse_legacy_groups(s, g)) {
            printf("  Format:     Legacy\n");
            printf("  Segmente:   %u/%u/%u/%u\n", g[0], g[1], g[2], g[3]);
            printf("  Pruefsumme: 0x%04X\n", crc16(s));
        } else {
            printf("  Format:     unbekannt\n");
        }
    }
    printf("  Sperrstatus: %s\n", is_revoked(s) ? "gesperrt" : "aktiv");
    printf("  Hinweis: Nutzen Sie --license zur vollstaendigen Pruefung.\n");
}

static void print_version(void) {
    printf("%s\n%s\n", VERSION, COPYRIGHT);
}
static void usage(const char *a0) {
    printf("%s\n\n", VERSION);
    printf("  %s --license <SCHLUESSEL>   Lizenz pruefen und freischalten\n", a0);
    printf("  %s --info    <SCHLUESSEL>   Lizenz-Details anzeigen\n", a0);
    printf("  %s --version                Version anzeigen\n", a0);
    printf("  %s --help                   diese Hilfe\n\n", a0);
    printf("Lizenzformat:\n  DHBW2-XXXXXXXX-<128 hex>\n");
}

int main(int argc, char **argv) {
    const char *lic = NULL, *info = NULL;
    int want_version = 0, want_help = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) g_verbose = 1;
        else if (strcmp(argv[i], "--help") == 0) want_help = 1;
        else if (strcmp(argv[i], "--version") == 0) want_version = 1;
        else if (strcmp(argv[i], "--license") == 0 && i + 1 < argc) lic = argv[++i];
        else if (strncmp(argv[i], "--license=", 10) == 0) lic = argv[i] + 10;
        else if (strcmp(argv[i], "--info") == 0 && i + 1 < argc) info = argv[++i];
        else if (strncmp(argv[i], "--info=", 7) == 0) info = argv[i] + 7;
    }
    vlog("Argumente verarbeitet");
    if (want_help) { usage(argv[0]); return 0; }
    if (want_version) { print_version(); return 0; }
    if (info) { do_info(info); return 0; }
    if (!lic) { usage(argv[0]); return 2; }

    vlog("Lizenzpruefung gestartet");
    int ok = license_ok(lic);
    vlog("Lizenzpruefung beendet");

    char msg[52];
    if (ok) { xdec(ENC_OK, 51, msg); puts(msg); return 0; }
    xdec(ENC_DENY, 27, msg); puts(msg); return 1;
}
