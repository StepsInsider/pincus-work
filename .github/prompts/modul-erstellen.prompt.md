---
name: modul-erstellen
description: Erstellt oder erweitert ein Pincus-Work-Fachmodul.
agent: agent
argument-hint: Welches Modul soll erstellt oder erweitert werden?
---

Erstelle bzw. erweitere das angegebene Pincus-Work-Modul.

Beachte:
- bestehendes UI
- Material 3
- responsive Desktop/Mobile
- klare Datenmodelle
- Formularvalidierung
- Testbarkeit

Das Modul darf nicht unnötig weiter in `main.dart` vergrößert werden.

Wenn eine neue Datei sinnvoll ist, lege sie an der passenden Stelle unter `lib/features/` an.

Nach der Änderung:
- `dart format .`
- `flutter analyze`
- relevante Tests
