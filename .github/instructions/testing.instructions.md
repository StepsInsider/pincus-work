---
description: Testregeln für Pincus Work
applyTo: "test/**/*.dart"
---

# Tests

Tests sollen die tatsächliche Pincus-Work-Anwendung prüfen.

Der bisherige Flutter-Standard-Counter-Test ist nicht mehr die fachliche Grundlage.

Tests sollen insbesondere prüfen:
- App startet
- Navigation funktioniert
- Module werden angezeigt
- Formulare können geöffnet werden
- Pflichtfelder werden validiert
- neue Einträge erscheinen nach dem Speichern

Bei neuen Modulen sollen relevante Widget-Tests ergänzt werden.
