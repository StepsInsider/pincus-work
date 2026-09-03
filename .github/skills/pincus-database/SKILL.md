---
name: pincus-database
description: Vorgehen zur späteren Einführung persistenter Datenhaltung.
---

# Persistente Datenhaltung

Vor Einführung einer Datenbank:

1. bestehende Models erfassen
2. Beziehungen zwischen Modulen definieren
3. Repository-Grenzen festlegen
4. Migrationstrategie planen
5. Web-Kompatibilität prüfen
6. Mobile/Desktop-Kompatibilität prüfen
7. Tests für Speicherung und Abruf erstellen

Die aktuelle Anwendung verwendet noch In-Memory-Listen.

Eine Datenbank darf nicht eingeführt werden, ohne die Auswirkungen auf Web, Mobile und Desktop zu prüfen.
