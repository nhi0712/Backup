# Nutzerdokumentation — LicenseForge CLI 2.4.1  [1P]

## Was die Anwendung tut
`validate` ist ein Kommandozeilen-Werkzeug zur Verwaltung von Produktlizenzen.
Es prüft einen Lizenzschlüssel und schaltet bei Gültigkeit die „Pro"-Funktion
frei; es arbeitet vollständig lokal (kein Netzwerk). Die vollständige
Bedienung entspricht der eingebauten Hilfe (`validate --help`):

```
LicenseForge CLI 2.4.1

  validate --license <SCHLUESSEL>   Lizenz pruefen und freischalten
  validate --info    <SCHLUESSEL>   Lizenz-Details anzeigen
  validate --version                Version anzeigen
  validate --help                   diese Hilfe

Lizenzformat:
  DHBW2-XXXXXXXX-<128 hex>
```

Zusätzlich: `-v` / `--verbose` gibt ausführliche Meldungen (zu stderr) aus.

## Exit-Codes
`0` gültig · `1` ungültig · `2` keine Lizenz angegeben (Hilfe wird gezeigt)

## Voraussetzungen
Ubuntu Linux 26.04 (x86-64), glibc. Keine weiteren Laufzeit-Abhängigkeiten.
