# RE-Challenge (ELF) – LicenseForge

Eine Kommandozeilen-Anwendung, die eine Produktlizenz prüft. Ziel des Reverse
Engineering: einen Lizenzschlüssel erzeugen, den `validate` akzeptiert
(Umgehung des Schutzmechanismus / Capture-the-Flag).

## Struktur

| Pfad | Rolle | Wer bekommt das? |
|---|---|---|
| `artifact/validate` | Die ausgelieferte, **stripped** ELF | **Angreifer** (nur das!) |
| `src/validate.c` | Quelltext der Anwendung | Prof (Abgabe „Sourcen") |
| `src/tweetnacl.{c,h}` | Vendored Ed25519 (TweetNaCl, public domain) | Prof |
| `build.sh` | Build-Script (`gcc -O2` + `strip`) | Prof |
| `tools/keygen.py` | Ausstellungs-Tool, **enthält Signier-Setup** | Prof (nicht an Angreifer!) |
| `tools/issuer_ed25519.key` | **Privater** Ed25519-Schlüssel | Prof (streng privat) |
| `solution/solve.py` | Angreifer-/Z3-Skript (gehört in die Reversing-Doku) | Prof |
| `AUFGABENSTELLUNG.md` | Aufgabenblatt (keine Lösung) | **Löser** + Prof |
| `doc/1_NUTZERDOKU.md` | Nutzerdoku = `--help` (keine Lösung) | **Löser** + Prof |

> Wichtig: Nur `artifact/validate` ist das Angriffsziel. Der private Schlüssel
> ist **nicht** im Binary – v2-Lizenzen sind daher nicht fälschbar. Die einzige
> Lücke ist der Legacy-Fallback auf das schwache v1-Format.
>
> **An die Löser gehen nur:** `AUFGABENSTELLUNG.md`, `doc/1_NUTZERDOKU.md` und
> `artifact/validate`. Alles andere (Sourcen, `tools/`, `solution/`,
> `doc/2_`, `doc/3_`) ist ausschließlich für den Prof.

## Dokumentation (Abgaben)

| Datei | Deliverable |
|---|---|
| `doc/1_NUTZERDOKU.md` | [1P] Nutzerdokumentation |
| `doc/2_REVERSING.md` | [5P] Reversing-Anleitung (Schritt für Schritt) |
| `doc/3_KI-EINSCHAETZUNG.md` | [2P] Einschätzung der KI-Resistenz + Harness |

## Bauen

```bash
./build.sh          # erzeugt artifact/validate (Ubuntu 26.04, x86-64)
```

Benötigt `gcc`, `strip`, `file`. Für `keygen.py`/`solve.py`:
`pip install pynacl z3-solver`.

## Benutzen

```bash
./artifact/validate --help
./artifact/validate --license DHBW2-XXXXXXXX-<128 hex>   # aktuelles Format
./artifact/validate --license DHBW1-XXXX-XXXX-XXXX-XXXX  # Alt-Format
```

Gültige Lizenz → `[OK] ... Pro-Funktion freigeschaltet.` (Exit 0),
sonst → `[DENIED] ...` (Exit 1).

Beispiel-Lizenzen erzeugen (nur mit privatem Schlüssel):

```bash
python3 tools/keygen.py v2 42     # gültige aktuelle Lizenz
python3 tools/keygen.py v1        # gültige Alt-Lizenz
```
