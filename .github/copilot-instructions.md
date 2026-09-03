# Pincus Work – Copilot Instructions

## Projekt

Pincus Work ist eine Flutter-Anwendung für René Pincus Baum- und Landschaftspflege.

Aktueller Stand:
- Flutter/Dart-Projekt
- Material 3
- responsive Desktop-/Mobile-Oberfläche
- aktuell zentrale Implementierung in `lib/main.dart`
- aktuell In-Memory-Datenhaltung
- noch keine produktive Datenbank
- noch keine Authentifizierung
- noch kein Backend

## Aktuelle Module

Die Anwendung enthält derzeit:

1. Dashboard
2. Baustellen
3. Zeiterfassung
4. Aufträge
5. Mitarbeiter
6. Fotos
7. Einstellungen

Diese Module sind aktuell über `AppModule` definiert.

## Zielarchitektur

Die Anwendung soll schrittweise von einem Prototyp zu einer wartbaren ERP-Anwendung entwickelt werden.

Zielstruktur:

lib/
  core/
  models/
  repositories/
  features/
    dashboard/
    sites/
    orders/
    time_tracking/
    employees/
    photos/
    settings/

Neue Fachlogik soll nicht dauerhaft in `main.dart` verbleiben.

`main.dart` soll langfristig nur noch App-Initialisierung und Routing enthalten.

## UI

Die bestehende Oberfläche ist die visuelle Grundlage.

Beibehalten:
- Material 3
- Pincus-Grün
- helle Oberflächen
- dezente Rahmen
- abgerundete Karten
- responsive Desktop-/Mobile-Darstellung
- linke Navigation auf Desktop
- untere Navigation auf Mobile

Bestehende Farben:
- Primary: #23863A
- Dark Green: #17672B
- Light Green: #EAF5EC
- Surface: #F7F8F6
- Border: #E2E7E2

Neue UI-Komponenten sollen sich optisch in dieses System einfügen.

## Daten

Aktuell werden Daten nur in Listen innerhalb des AppShell-State gehalten.

Beispiele:
- `sites`
- `timeEntries`
- `orders`
- `employees`
- `photos`

Wenn ein Modul erweitert wird, muss zwischen UI, Model und Datenhaltung unterschieden werden.

Keine unnötigen globalen Variablen.

## Fachmodule

### Baustellen
Verwaltet:
- Baustellenname
- Kunde
- Adresse
- Status

### Aufträge
Verwaltet:
- Auftragsnummer
- Bezeichnung
- Kunde
- Status

### Zeiterfassung
Verwaltet:
- Mitarbeiter
- Baustelle
- Datum
- Beginn
- Ende
- Pause
- Tätigkeit

### Mitarbeiter
Verwaltet:
- Name
- Rolle/Tätigkeit
- Telefon

### Fotos/Dokumentation
Verwaltet:
- Baustelle
- Beschreibung
- später echte Bilddatei

## Entwicklungsregeln

Vor Änderungen:
1. Bestehenden Code lesen.
2. Abhängigkeiten prüfen.
3. Bestehende Funktionalität erhalten.
4. Kleine nachvollziehbare Änderungen durchführen.

Nach Änderungen:
1. `dart format .`
2. `flutter analyze`
3. relevante Tests ausführen
4. bei Web-Änderungen zusätzlich `flutter build web --release`

Keine Funktionalität entfernen, nur weil sie noch ein Prototyp ist, ohne dies ausdrücklich zu begründen.

## Definition of Done

Eine Änderung ist erst fertig, wenn:
- sie kompiliert,
- `flutter analyze` keine neuen Fehler verursacht,
- relevante Tests funktionieren,
- Desktop und Mobile berücksichtigt wurden,
- die bestehende Pincus-Oberfläche erhalten bleibt,
- Datenflüsse nachvollziehbar sind.

## Wichtig

Nicht blind neue Packages hinzufügen.

Vor Einführung einer Datenbank oder eines Backends zuerst die aktuelle Architektur prüfen.

Keine künstlichen Mock-Daten als Ersatz für eine echte Datenhaltung einführen, wenn das Ziel die Implementierung produktiver Datenhaltung ist.
