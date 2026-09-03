---
name: pincus-module
description: Vorgehen zum Erstellen eines neuen Pincus-Work-Fachmoduls.
---

# Pincus Work Modul

Beim Erstellen eines Moduls:

1. Fachliche Aufgabe definieren.
2. benötigte Daten bestimmen.
3. Model von UI trennen.
4. Feature unter `lib/features/<modul>/` strukturieren.
5. Liste und Detail-/Eingabemaske trennen.
6. Validierung implementieren.
7. Navigation anbinden.
8. Widget-Tests ergänzen.
9. `dart format .`
10. `flutter analyze`
11. relevante Tests.

Keine unnötige Abhängigkeit hinzufügen.
