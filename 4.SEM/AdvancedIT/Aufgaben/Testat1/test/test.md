# Testdokumentation: Steuerung von Loks (Erzeuger/Verbraucher und private Semaphoren)

---
# Aufgabe (a)

## Testfall 1: Lok 1 ist deutlich schneller als Lok 0
**Parameter:** Lok 0 Geschwindigkeit = 1 | Lok 1 Geschwindigkeit = 5
**Ziel des Tests:** Es muss bewiesen werden, dass eine schnelle Lok nicht zweimal hintereinander in das kritische Mittelstück befahren darf, sondern an der Weiche warten muss, bis die langsamere Lok ihre Runde beendet hat.

**Konsolenausgabe:**
```text
[  0,015s] Lok 1: startet ihre Fahrt, mit 5 Einheiten pro Sekunde.
[  0,040s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,015s] Lok 0: startet ihre Fahrt, mit 1 Einheiten pro Sekunde.
[  0,042s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,042s] Lok 0: befährt das gemeinsame Mittelstück.
[  5,053s] Lok 0: verlässt das Mittelstück...
[  5,054s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  5,054s] Lok 1: befährt das gemeinsame Mittelstück.
[  6,057s] Lok 1: verlässt das Mittelstück...
[  6,057s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  8,072s] Lok 1: erreicht die Weiche und wartet ggf.
[ 15,059s] Lok 0: erreicht die Weiche und wartet ggf.
[ 15,059s] Lok 0: befährt das gemeinsame Mittelstück.
[ 20,069s] Lok 0: verlässt das Mittelstück...
[ 20,069s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[ 20,069s] Lok 1: befährt das gemeinsame Mittelstück.
```

**Fazit:** Wie in der Ausgabe ersichtlich, beendet Lok 1 ihre Runde auf dem privaten Kreis sehr schnell und erreicht die Weiche erneut. Sie betritt das Mittelstück jedoch nicht, sondern blockiert und wartet korrekt, bis Lok 0 das Mittelstück verlässt und die Erlaubnis erteilt.

---

## Testfall 2: Lok 0 ist deutlich schneller als Lok 1
**Parameter:** Lok 0 Geschwindigkeit = 5 | Lok 1 Geschwindigkeit = 1
**Ziel des Tests:** Es muss bewiesen werden, dass die Funktionalität auch andersrum greift.

**Konsolenausgabe:**
```text
[  0,013s] Lok 1: startet ihre Fahrt, mit 1 Einheiten pro Sekunde.
[  0,033s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,013s] Lok 0: startet ihre Fahrt, mit 5 Einheiten pro Sekunde.
[  0,035s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,035s] Lok 0: befährt das gemeinsame Mittelstück.
[  1,043s] Lok 0: verlässt das Mittelstück...
[  1,043s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  1,043s] Lok 1: befährt das gemeinsame Mittelstück.
[  3,053s] Lok 0: erreicht die Weiche und wartet ggf.
[  6,055s] Lok 1: verlässt das Mittelstück...
[  6,055s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  6,056s] Lok 0: befährt das gemeinsame Mittelstück.
[  7,061s] Lok 0: verlässt das Mittelstück...
[  7,061s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  9,064s] Lok 0: erreicht die Weiche und wartet ggf.
```

**Fazit:** Die Ausgabe bestätigt die korrekte Funktionalität.

---

## Testfall 3: Identische Geschwindigkeiten
**Parameter:** Lok 0 Geschwindigkeit = 2 | Lok 1 Geschwindigkeit = 2
**Ziel des Tests:** Überprüfung des regulären Betriebsflusses bei gleicher Auslastung, um sicherzustellen, dass keine Deadlocks (Verklemmungen) entstehen.

**Konsolenausgabe:**
```text
[  0,013s] Lok 1: startet ihre Fahrt, mit 2 Einheiten pro Sekunde.
[  0,034s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,013s] Lok 0: startet ihre Fahrt, mit 2 Einheiten pro Sekunde.
[  0,036s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,037s] Lok 0: befährt das gemeinsame Mittelstück.
[  2,541s] Lok 0: verlässt das Mittelstück...
[  2,541s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  2,541s] Lok 1: befährt das gemeinsame Mittelstück.
[  5,049s] Lok 1: verlässt das Mittelstück...
[  5,049s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  7,557s] Lok 0: erreicht die Weiche und wartet ggf.
[  7,557s] Lok 0: befährt das gemeinsame Mittelstück.
[ 10,063s] Lok 1: erreicht die Weiche und wartet ggf.
[ 10,063s] Lok 0: verlässt das Mittelstück...
[ 10,064s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[ 10,064s] Lok 1: befährt das gemeinsame Mittelstück.
```

**Fazit:** Beide Loks wechseln sich flüssig und ohne lange Wartezeiten ab. Das System läuft stabil in einer Endlosschleife, der wechselseitiger Ausschluss im Mittelstück ist stets gegeben.

# Aufgabe (b)

Entpsricht den gleichen Testfällen aus Aufgabe (a) mit identischen Werten.

## Testfall 1: Lok 1 ist deutlich schneller als Lok 0
**Parameter:** Lok 0 Geschwindigkeit = 1 | Lok 1 Geschwindigkeit = 5
```text
[  0,001s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,001s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,028s] Lok 0: befährt das gemeinsame Mittelstück.
[  5,035s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  5,035s] Lok 1: befährt das gemeinsame Mittelstück.
[  6,041s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  8,046s] Lok 1: erreicht die Weiche und wartet ggf.
[ 15,048s] Lok 0: erreicht die Weiche und wartet ggf.
[ 15,048s] Lok 0: befährt das gemeinsame Mittelstück.
[ 20,061s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[ 20,061s] Lok 1: befährt das gemeinsame Mittelstück.
```

## Testfall 2: Lok 0 ist deutlich schneller als Lok 1
**Parameter:** Lok 0 Geschwindigkeit = 5 | Lok 1 Geschwindigkeit = 1
```text
[  0,001s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,001s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,025s] Lok 0: befährt das gemeinsame Mittelstück.
[  1,028s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  1,028s] Lok 1: befährt das gemeinsame Mittelstück.
[  3,043s] Lok 0: erreicht die Weiche und wartet ggf.
[  6,040s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  6,040s] Lok 0: befährt das gemeinsame Mittelstück.
[  7,045s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  9,080s] Lok 0: erreicht die Weiche und wartet ggf.
[ 16,056s] Lok 1: erreicht die Weiche und wartet ggf.
[ 16,056s] Lok 1: befährt das gemeinsame Mittelstück.
[ 21,069s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[ 21,069s] Lok 0: befährt das gemeinsame Mittelstück.
```

## Testfall 3: Identische Geschwindigkeiten
**Parameter:** Lok 0 Geschwindigkeit = 2 | Lok 1 Geschwindigkeit = 2
```text
[  0,001s] Lok 0: erreicht die Weiche und wartet ggf.
[  0,001s] Lok 1: erreicht die Weiche und wartet ggf.
[  0,035s] Lok 0: befährt das gemeinsame Mittelstück.
[  2,546s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  2,546s] Lok 1: befährt das gemeinsame Mittelstück.
[  5,055s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[  7,550s] Lok 0: erreicht die Weiche und wartet ggf.
[  7,550s] Lok 0: befährt das gemeinsame Mittelstück.
[ 10,051s] Lok 0: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
[ 10,066s] Lok 1: erreicht die Weiche und wartet ggf.
[ 10,066s] Lok 1: befährt das gemeinsame Mittelstück.
[ 12,573s] Lok 1: hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.
```