---
name: pincus-release
description: Prüft Pincus Work vor einem Release.
---

# Release Check

Vor einem Release:

1. `dart format .`
2. `flutter analyze`
3. `flutter test`
4. `flutter build web --release`
5. Git-Diff prüfen
6. keine versehentlichen Debug-/Teständerungen
7. wichtige Funktionen manuell prüfen

Besonders prüfen:
- Dashboard
- Baustellen
- Aufträge
- Zeiterfassung
- Mitarbeiter
- Fotos
- Navigation
- responsive Darstellung
