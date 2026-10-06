# Reversing-Dokumentation  [5P]  (Musterlösung – nicht an Löser aushändigen)

## Ziel
Der Angreifer hat nur die stripped ELF `validate`. Ziel: einen Schlüssel
erzeugen, den `validate` akzeptiert (Schutz umgehen) — ohne privaten Schlüssel.

## Wo das Sicherheitsproblem liegt
Neben dem aktuellen, **Ed25519-signierten** `DHBW2`-Format akzeptiert `validate`
weiterhin ein **undokumentiertes Legacy-Format `DHBW1`** (Downgrade). Dessen
„Schutz" ist nur eine Prüfsumme aus drei Relationen über vier 16-Bit-Zahlen —
mit einem SMT-Solver trivial erfüllbar. Verwechslung von *Integrität*
(Prüfsumme) mit *Authentizität* (Signatur) + aktiver Alt-Pfad. Zusätzliche
Hürden: die Vergleichskonstanten stehen nicht im Klartext (Laufzeit-Ableitung),
Meldungen/Präfix sind verschlüsselt, mehrere Decoys lenken ab.

## Tools
`file`, `strings`, `objdump`, **Ghidra** (Decompiler); optional **gdb**
(dynamische Konstanten-Recovery); **Python 3 + z3-solver**.
Skript: `solution/solve.py`.

## Schritte (nachvollziehbar)
1. **Recon:** `file validate` → stripped/PIE. `strings -a validate` zeigt UI,
   `DHBW2-` und `expand 32-byte k` (Krypto) — aber **kein** Legacy-Format und
   **keine** `[OK]/[DENIED]` (verschlüsselt).
2. **Ghidra → `main`** (über Entry-Point oder XREF auf den Usage-Text). Der
   `--license`-Pfad hat **drei** verdächtige Kandidaten:
   - Ed25519-Verify (großer Block, `expand 32-byte k`): nur Public Key im
     Binary → **nicht fälschbar** = Nebelkerze.
   - Sperrlisten-Hash (FNV gegen Tabelle): blockiert nur → Decoy.
   - **Kompatibilitäts-Parser** (für Eingaben, die *nicht* mit `DHBW2-`
     beginnen): der echte Angriffspunkt.
3. **Legacy-Format rekonstruieren:** der Präfix wird zur Laufzeit XOR-dekodiert
   → `DHBW1-`; Format `DHBW1-XXXX-XXXX-XXXX-XXXX` (4×16 Bit). Dass es dieses
   Format gibt, verrät die Hilfe nicht — **Doku ≠ Code** ist der Kern.
4. **Prüfung lesen:** aus a,b,c,d werden `S=a+b+c+d`, `X=a^b^c^d`,
   `P=a*b+c*d` gebildet und (gefaltet) gegen abgeleitete Zielwerte verglichen.
   Die Zielwerte sind **keine** Immediates — sichtbar sind nur maskierte Werte
   `0x5610/0x6786/0xC616` und eine Tabelle `T`, aus der zur Laufzeit ein
   Schlüssel `k` abgeleitet wird.
5. **Konstanten rekonstruieren** — zwei Wege:
   - *statisch:* Ableitungsschleife + Maskenformeln nachbauen und mit den
     BLOB-Werten XOR-en (in `solve.py` umgesetzt), **oder**
   - *dynamisch (gdb):* Breakpoint an der Vergleichsstelle (`xor …,0x5610`),
     mit beliebigem `DHBW1-`-Key laufen lassen, `k`/Zielwerte aus den Registern
     lesen.
   Ergebnis: **C1=0x2568, C2=0x0888, C3=0x18DE**.
6. **Forgen:** `python3 solution/solve.py` löst `S=C1, X=C2, P=C3` mit Z3 und
   gibt einen gültigen Schlüssel aus (z. B. `DHBW1-DAD3-FC59-3C1D-121F`).
7. **Verifizieren:** `./validate --license <Key>` → `[OK]`.

## Befehle (copy-paste)
```
file validate
strings -a validate | grep -i dhbw
objdump -d -M intel validate | grep -iE '0x5610|0x6786|0xc616'   # maskierte Zielwerte
pip install z3-solver && python3 solution/solve.py
./validate --license <ausgegebener Key>
```

## Alternative
Binär-Patch: den bedingten Sprung nach der Faltung invertieren/NOPen → nimmt
jede Eingabe an. Erzeugt aber keinen Schlüssel; Forgen ist der saubere Weg.
