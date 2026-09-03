---
description: Flutter- und Dart-Regeln für Pincus Work
applyTo: "**/*.dart"
---

# Flutter / Dart

Verwende null-sicheren Dart-Code.

Bevorzuge:
- kleine Widgets
- klare Verantwortlichkeiten
- `const`, wo sinnvoll
- Material 3
- responsive Layouts
- sprechende Namen

Vermeide:
- unnötige Abhängigkeiten
- riesige Widget-Methoden
- doppelte Logik
- Businesslogik direkt in UI-Widgets

Neue Fachmodule sollen langfristig unter `lib/features/` organisiert werden.

`lib/main.dart` soll nicht weiter zu einer monolithischen Datei wachsen.
