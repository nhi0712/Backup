#!/usr/bin/env python3
"""
LicenseForge - internes Ausstellungs-Tool.  NICHT Teil des ausgelieferten
Binaries.  Enthaelt den PRIVATEN Signierschluessel und darf NICHT an Kunden
(bzw. Reverse-Engineers) gelangen - nur die 'validate'-ELF wird ausgeliefert.

  ./keygen.py v2 <kundennr>   -> gueltige aktuelle Lizenz (Ed25519-signiert)
  ./keygen.py v1              -> gueltige Alt-Lizenz (self-validating serial)
  ./keygen.py pk              -> C-Array des oeffentlichen Schluessels (Einbettung)
"""
import sys, os, nacl.signing

KEYFILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "issuer_ed25519.key")  # 32-Byte Seed

def load_key() -> nacl.signing.SigningKey:
    try:
        seed = open(KEYFILE, "rb").read()
        return nacl.signing.SigningKey(seed)
    except FileNotFoundError:
        sk = nacl.signing.SigningKey.generate()
        open(KEYFILE, "wb").write(bytes(sk))
        return sk

SK = load_key()
PK = bytes(SK.verify_key)

# --- v2: Ed25519-signierte Lizenz ---------------------------------------
def make_v2(customer: int) -> str:
    payload = customer.to_bytes(4, "big")
    sig = SK.sign(payload).signature            # 64 Byte
    return "DHBW2-" + payload.hex().upper() + "-" + sig.hex().upper()

# --- v1: historisches self-validating serial ----------------------------
def v1_checks(w, x, y, z):
    return ((w + x + y + z) & 0xFFFF,
            (w ^ x ^ y ^ z) & 0xFFFF,
            (w * x + y * z) & 0xFFFF)

GEN = (0x1A2B, 0x3C4D, 0x5E6F, 0x7081)          # eine echt ausgestellte Alt-Lizenz
C1, C2, C3 = v1_checks(*GEN)

def make_v1(w, x, y, z) -> str:
    return f"DHBW1-{w:04X}-{x:04X}-{y:04X}-{z:04X}"

def pk_c_array() -> str:
    return "{" + ", ".join("0x%02x" % b for b in PK) + "}"

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
    if cmd == "v2":
        print(make_v2(int(sys.argv[2])))
    elif cmd == "v1":
        print(make_v1(*GEN))
    elif cmd == "pk":
        print("PK  hex :", PK.hex())
        print("PK  C   :", pk_c_array())
        print("v1-Konstanten: C1=0x%04X C2=0x%04X C3=0x%04X" % (C1, C2, C3))
    else:
        print(__doc__)
