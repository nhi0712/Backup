# KI-Einschätzung  [2P]

## Eigene Testdurchläufe
- **Ohne Härtung:** eine Chat-KI löste die Challenge in **~15 Min / 3 Prompts**,
  **rein statisch** (`strings` + Decompilat einfügen → Konstanten ablesen →
  Z3), fertiger Key.
- **Mit Härtung, assistiert (Chat):** deutlich mehr Aufwand — die KI musste
  `main` per XREF finden, das Decompilat schrittweise posten, hielt sogar **den
  falschen Pfad für den Decoy** und ging erst danach Richtung dynamischer
  Schlüssel-Extraktion. Aus einem Ein-Schritt-Read wurde eine mehrstufige
  Sitzung mit Werkzeugbedarf.
- **Mit Härtung, vollautonom:** ein Coding-Agent (Claude Code mit Sonnet) löste
  die Challenge **komplett eigenständig in ~32 Minuten**. Ablauf:
  - *Umgebung:* kein lokales RE-Tooling (Windows); der Agent fand eine
    vorhandene **WSL-Ubuntu** und nutzte sie, um die Linux-ELF auszuführen.
  - *Werkzeuge:* `objdump -d`, `readelf` (.rodata/.data), später `gdb` — **kein
    Ghidra, kein Z3**. Das Gleichungssystem löste er mit einem **selbst
    geschriebenen C-Bruteforce**.
  - *Vorgehen:* XOR-0x5A-Strings von Hand entschlüsselt; die zwei Formate
    erkannt; v2 als „zu starke" Signatur (er tippte auf RSA/Rabin) korrekt als
    Sackgasse verworfen; die Legacy-Prüfsumme (Summe, XOR, multiplikativer
    Querterm + 16-Runden-Scrambler über Konstantentabelle) zu drei Gleichungen
    reduziert.
  - *Probleme:* sein erster Key erfüllte seine
    Gleichungen, wurde aber **abgelehnt** — er hatte die verschleierte Ableitung
    falsch transkribiert (`imul …,0x9e37` mit `rol …,5` verwechselt). Er musste
    per **gdb-Single-Stepping** die echten Registerwerte gegen sein Modell
    prüfen und den Fehler korrigieren.
  - *Ergebnis:* gültiger Key `DHBW1-1C4B-DEAD-384F-F221`, Exit 0 — ohne echten
    privaten Schlüssel.

## Bedrohungsmodelle
- **Reines Chat-LLM (nur Text):** scheitert — eine stripped ELF ist ohne
  Disassembler unlesbar, Vorschläge lassen sich nicht ausführen/verifizieren.
- **LLM mit vorgelegtem Decompilat (assistiert):** erkennt die Pfade,
  verrechnet sich aber an der verschleierten, gekoppelten Ableitung und kann
  ohne Ausführung nicht verifizieren.
- **Vollautonomer Agent mit Werkzeugkette:** löst es — **belegt (~32 Min)**,
  deutlich unter dem 90-Minuten-Budget.

## Benötigtes Harness (autonomer Agent)
| Komponente | Wofür |
|---|---|
| Linux-Laufzeit (WSL / Container) | die ELF überhaupt ausführen |
| Disassembler `objdump`/`readelf` (oder Ghidra) | Code + .rodata/.data lesen |
| Code-Ausführung (Shell) | eigene Skripte/C-Programme bauen & laufen lassen |
| Solver **oder** Bruteforce | Gleichungssystem lösen — Z3 **oder** selbst geschriebener C-Bruteforce (Summe+XOR kollabieren den Suchraum auf ~2³²) |
| `gdb` (genutzt, nicht optional) | die nicht materialisierten Konstanten dynamisch verifizieren/korrigieren |

## Was die KI real bremst – und was nicht
- **Wirksam:** die **nicht materialisierten Konstanten**. Sie waren der einzige
  Punkt, an dem selbst der autonome Agent strauchelte (Fehl-Transkription →
  falscher Key → erzwungenes gdb-Single-Stepping).
- **Etwas wirksam:** Decoy-Mehrdeutigkeit (der assistierte Lauf hielt den
  Legacy-Pfad fälschlich für den Decoy), verschlüsselte Meldungen (kein
  XREF-Shortcut), Ed25519 als Red Herring (der Agent ließ v2 als „zu stark" links
  liegen).
- **Kaum wirksam:** Stripping/Obfuskation an sich — der Agent las die
  `objdump`-Ausgabe problemlos; das Finden der Lücke kostete ihn wenig Zeit.

## Bewusst nicht eingesetzt
In der Konzeption haben wir auch Härtungen erwogen, die nicht das Verstehen, sondern das Ausführen angreifen: Anti-Debugging (z. B. ptrace-Erkennung), Environment-Keying (läuft nur bei passendem Datum/Hostname), Anti-VM-Erkennung und Packer. Wir haben uns bewusst dagegen entschieden: Sie verschieben den Charakter der Aufgabe weg vom logik- und verständnisbasierten Reversing, und sie sind fragil — solche Mechanismen können in der Umgebung des Korrektors gar nicht erst anlaufen und die Lösung ganz verhindern, statt sie nur zu erschweren.

## Fazit
Entscheidend ist der **Angreifertyp**. Ein vollautonomer KI-Agent liest auch
stripped-/obfuskierten Code mühelos: ist die Legacy-Funktion erst sichtbar, ist
die Lücke faktisch sofort erkannt — Stripping kostet ihn kaum Zeit. Auch das
Ausnutzen ist keine echte Hürde: das (nichtlineare) Gleichungssystem lässt sich
per Z3 **oder** C-Bruteforce in Minuten lösen (Summe+XOR kollabieren den Raum auf
~2³²; ein SMT-Solver ist bequem, aber nicht zwingend). Der **einzige** Baustein,
der selbst den autonomen Agenten spürbar aufhielt, war die **erzwungene
Dynamik** durch die nicht materialisierten Konstanten — er musste zu gdb greifen.

Belegt: Der Agent löste die gehärtete Challenge **autonom in ~32 Min**. Für einen
**menschlichen** Reverser wirkt dieselbe Verschleierung deutlich stärker, weil
Lesen und Rekonstruieren von Hand viel länger dauern.

Gesamtbild: Verschleierung erhöht vor allem die Hürde für Menschen; einen gut
ausgestatteten KI-Agenten (Linux-Laufzeit + Disassembler + Code-Ausführung +
gdb) **verzögert** sie nur, **hält** ihn aber **nicht auf** — konsistent mit
„Sicherheit durch Verschleierung ist keine Sicherheit". Der belegbare Wert des
Designs: es macht das nötige Harness explizit und messbar — und zeigt, dass der
einzige echte Zeitfresser die erzwungene dynamische Analyse ist, nicht die
Obfuskation selbst.
