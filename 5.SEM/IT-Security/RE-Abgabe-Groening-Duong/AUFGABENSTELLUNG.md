# Reverse-Engineering-Challenge: „LicenseForge"

## Szenario
Die Firma *LicenseForge* verkauft Pro-Software, die erst mit gültigem
**Lizenzschlüssel** freischaltet. Dir liegt nur das Prüfprogramm `validate`
vor — kein gültiger Schlüssel, kein Quellcode.

## Deine Aufgabe
Umgehe den Schutzmechanismus: **bringe `validate` dazu, eine Lizenz zu
akzeptieren, ohne einen echten Schlüssel zu besitzen.** Erfolg sieht so aus:

```
$ ./validate --license <DEIN-SCHLUESSEL>
[OK] Lizenz gueltig - Pro-Funktion freigeschaltet.
```

Der Schlüssel, den du dafür erzeugst, **ist** deine Flag.

## Was du bekommst
Nur die Binary `validate` (Linux, x86-64, stripped). Kein Quellcode, kein
Server — die Prüfung läuft vollständig lokal.

## Umgebung
Ubuntu Linux 26.04 (x86-64), Kommandozeile:

```
chmod +x validate
./validate --help
```

## Spielregeln
- **Erlaubt:** alle Standard-RE-Werkzeuge (`strings`, `objdump`, Ghidra,
  `gdb`, …), eigene Skripte und **KI-Unterstützung**.
- Es geht um das *Verständnis* des Prüfmechanismus, nicht um Angriffe auf
  Infrastruktur.
- Eleganter als die Binary zu patchen: einen **gültigen Schlüssel erzeugen**.

## Abgabe
1. Der funktionierende Lizenzschlüssel (mit `[OK]`-Ausgabe als Beleg).
2. Kurzbeschreibung: **Wo liegt das Sicherheitsproblem, wie hast du es
   ausgenutzt?**
3. Die verwendeten Tools und Skripte.

## Aufwand
Mit KI-Unterstützung ca. **90 Minuten**.

## Tipp
Statische Analyse allein bringt dich nicht immer ans Ziel — beobachte auch das
Laufzeitverhalten und probiere verschiedene Eingaben aus.
