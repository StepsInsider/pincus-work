# Projektanalyse: Pincus Work

Stand: 2026-09-03

## Kurzfazit

Pincus Work ist ein Flutter-/Dart-Prototyp mit Material 3 und einer responsiven Oberflaeche fuer Desktop und Mobile. Der gesamte sichtbare Anwendungsfluss ist aktuell in `lib/main.dart` konzentriert: App-Initialisierung, Theme, Navigation, Modelle, State, Screens und Formular-Dialoge liegen in einer Datei. Die Module funktionieren ueber lokale Listen im `AppShell`-State, aber Daten gehen beim Neustart verloren und es gibt aktuell keine produktive Persistenz, Authentifizierung oder Backend-Anbindung.

Die groesste technische Prioritaet ist deshalb die schrittweise Trennung von UI, Modellen und Datenhaltung, ohne die bestehende Oberflaeche und die bereits vorhandenen Arbeitsablaeufe zu verlieren.

Der ausdruecklich gepruefte vermeintliche Syntaxfehler in Zeile 332 ist kein Syntaxfehler: `flutter analyze` akzeptiert den Code und meldet dort lediglich den Info-Lint `use_null_aware_elements` fuer `if (action != null) action!`.

## Ist-Zustand

### Struktur und Technologien

- Flutter-/Dart-Projekt mit SDK-Anforderung `^3.12.2` in `pubspec.yaml`.
- Abhaengigkeiten sind auf Flutter, `cupertino_icons` sowie Test- und Lint-Pakete begrenzt.
- `lib/main.dart` ist der aktive Einstiegspunkt und enthaelt die komplette prototypische Anwendung.
- Verzeichnisse `lib/models/`, `lib/repositories/` und `lib/screens/` existieren, enthalten nach der aktuellen Dateisuche aber keine Dart-Dateien.
- `analysis_options.yaml` aktiviert die empfohlenen Flutter-Lints.

### Navigation und Layout

- `PincusWorkApp` erstellt das `MaterialApp`, setzt Material 3 und definiert das gruene Pincus-Farbschema.
- `AppModule` bildet sieben Bereiche ab: Dashboard, Baustellen, Zeiterfassung, Auftraege, Mitarbeiter, Fotos und Einstellungen.
- `_AppShellState` verwaltet das aktive Modul und reicht Listen sowie Callback-Funktionen an `_Content` weiter.
- Unterhalb von 760 Pixeln wird die Sidebar durch `_MobileNav` ersetzt; auf groesseren Breiten erscheint `_Sidebar`.
- `_Content` verwendet einen `SingleChildScrollView` und begrenzt die Inhaltsbreite auf 1180 Pixel.

### Fachmodule und Daten

Die Domänenobjekte `Site`, `TimeEntry`, `OrderItem`, `Employee` und `PhotoItem` sind mutable Klassen in `lib/main.dart`. Ihre Instanzen werden in Listen des `_AppShellState` gehalten:

- `sites`: zwei initiale Baustellen.
- `timeEntries`: initial leer.
- `orders`: zwei initiale Auftraege.
- `employees`: zwei initiale Mitarbeiter.
- `photos`: initial leer.

Neue Objekte werden ueber `_addSite`, `_addTime`, `_addOrder`, `_addEmployee` und `_addPhoto` mit `setState` am Anfang der jeweiligen Liste eingefuegt. Es gibt keine Lade-, Speicher-, Update- oder Loeschoperationen ausserhalb dieses lokalen State-Flusses.

### Interaktionen

- Dashboard-Karten und Quick Actions wechseln das aktive `AppModule`.
- Baustellen, Zeiten, Auftraege, Mitarbeiter und Fotodokumentationen werden ueber Dialoge angelegt.
- `_showTimeForm` und `_showPhotoForm` verwenden Baustellen beziehungsweise Mitarbeiter als Dropdown-Quellen.
- Formularvalidierung prueft nur einzelne Pflichtfelder. Datums-, Zeit-, Pausen- und Auftragsnummernwerte werden nicht fachlich validiert.
- Fotos speichern aktuell nur Baustelle und Beschreibung; eine Bilddatei wird noch nicht verwaltet.

## Befunde

### 1. Zentrale Datei als Skalierungsrisiko

- **Prioritaet:** hoch
- **Beobachtung:** `lib/main.dart` enthaelt Initialisierung, Theme, Enum, fuenf Datenklassen, AppShell-State, Navigation, alle Modul-Screens, wiederverwendbare UI-Bausteine und Formularlogik.
- **Auswirkung:** Aenderungen an einem Fachmodul beruehren eine grosse gemeinsame Datei. Verantwortlichkeiten, Testbarkeit und spaetere parallele Entwicklung werden erschwert.
- **Beleg:** `lib/main.dart`, `PincusWorkApp`, `_AppShellState`, `_Content`, `_Dashboard`, `_Sites`, `_TimeTracking`, `_Orders`, `_Employees`, `_Photos`, `_Settings`.

### 2. Daten sind nur fluechtiger In-Memory-State

- **Prioritaet:** hoch
- **Beobachtung:** Die Listen `sites`, `timeEntries`, `orders`, `employees` und `photos` werden direkt im `_AppShellState` initialisiert und nur mit `setState` veraendert.
- **Auswirkung:** Angelegte Daten sind nach einem App-Neustart verloren. Mehrere Geraete, Benutzer, Offline-Synchronisation und belastbare Historie sind damit nicht moeglich.
- **Beleg:** `lib/main.dart`, `_AppShellState`, `_addSite`, `_addTime`, `_addOrder`, `_addEmployee`, `_addPhoto`.

### 3. Zielstruktur ist vorbereitet, aber noch nicht aktiv

- **Prioritaet:** mittel
- **Beobachtung:** `lib/models/`, `lib/repositories/` und `lib/screens/` sind vorhanden, aber die aktive Implementierung importiert daraus keine Dart-Dateien.
- **Auswirkung:** Die Ordner vermitteln bereits eine Zielrichtung, reduzieren aber aktuell weder die Kopplung noch die Dateigroesse von `main.dart`.
- **Beleg:** Projektstruktur und `lib/main.dart`; Zielstruktur in `.github/copilot-instructions.md`.

### 4. Testabdeckung prueft nicht die aktuelle Anwendung

- **Prioritaet:** hoch
- **Beobachtung:** `test/widget_test.dart` importiert `PincusWorkApp`, erwartet aber die Standard-Counter-Oberflaeche mit den Texten `0` und `1` sowie einem Plus-Icon.
- **Auswirkung:** Der Test beschreibt nicht das aktuelle Produktverhalten und kann den zentralen Dashboard-/Navigations-/Formularfluss nicht absichern. Der aktuelle Lauf scheitert beim Tippen auf das nicht vorhandene Plus-Icon in `test/widget_test.dart:23`.
- **Beleg:** `test/widget_test.dart`, Test `Counter increments smoke test`; aktuelle Startseite in `lib/main.dart`, `PincusWorkApp` und `AppShell`.

### 5. Analyse meldet keinen Syntaxfehler, aber einen Stilhinweis

- **Prioritaet:** niedrig
- **Beobachtung:** `flutter analyze` beendet sich ohne Fehler, meldet aber `use_null_aware_elements` an `lib/main.dart:332`.
- **Auswirkung:** Der Hinweis betrifft die Schreibweise des optionalen `action`-Elements in `_PageHeader`, nicht die syntaktische Gueltigkeit oder den Laufzeitfluss. Er kann bei einer spaeteren Formatierungs- oder Lintbereinigung behoben werden.
- **Beleg:** `_PageHeader.build`, `if (action != null) action!`; Analyseausgabe vom 2026-09-03.

### 6. Fachliche Eingaben sind nur oberflaechlich validiert

- **Prioritaet:** mittel
- **Beobachtung:** Die Formularfunktionen pruefen vor allem leere Pflichtfelder. `_showTimeForm` akzeptiert Datum, Start, Ende und Pause als freie Strings; `_showOrderForm` akzeptiert auch eine leere Auftragsnummer.
- **Auswirkung:** Ungueltige Zeitspannen, negative oder nicht numerische Pausen, falsche Datumsformate und doppelte oder unvollstaendige Auftragsnummern koennen in den State gelangen.
- **Beleg:** `lib/main.dart`, `_showTimeForm`, `_showOrderForm`, `_showSiteForm`, `_showEmployeeForm`, `_showPhotoForm`.

### 7. Mobile Navigation deckt nicht alle Module direkt ab

- **Prioritaet:** niedrig
- **Beobachtung:** `_MobileNav` listet nur Dashboard, Baustellen, Zeit, Auftraege und Mitarbeiter. Fotos und Einstellungen sind dort nicht direkt vertreten.
- **Auswirkung:** Auf kleinen Bildschirmen fehlt ein direkter Navigationsweg zu zwei vorhandenen Bereichen, sofern keine andere UI-Verknuepfung genutzt wird.
- **Beleg:** `lib/main.dart`, `_MobileNav`; `AppModule.photos` und `AppModule.settings`.

## Offene Fragen

- Soll die erste produktive Persistenz lokal, serverseitig oder als Kombination aus beidem erfolgen?
- Wird ein Benutzer- und Rollenmodell benoetigt, insbesondere fuer Mitarbeiter und Geschaeftsfuehrung?
- Sollen Baustellen, Kunden und Auftraege eigene stabile IDs erhalten, bevor Repositories eingefuehrt werden?
- Welche fachlichen Formate und Regeln gelten fuer Arbeitszeiten, Pausen, Statuswerte und Auftragsnummern?
- Muessen Fotos lokal aufgenommen, hochgeladen oder nur referenziert werden?

## Empfehlungen

1. **Testbaseline korrigieren:** Den Counter-Test durch einen Smoke-Test fuer `PincusWorkApp` ersetzen: Dashboard sichtbar, Modulwechsel funktioniert, leerer Zustand fuer Zeiterfassung sichtbar.
2. **Lint-Hinweis bereinigen:** Die optionale Action-Ausgabe in `_PageHeader` auf die vom Analyzer vorgeschlagene null-aware Schreibweise umstellen, sobald Anwendungsdateien wieder bearbeitet werden duerfen.
3. **Modelle auslagern:** `Site`, `TimeEntry`, `OrderItem`, `Employee` und `PhotoItem` nach `lib/models/` verschieben. Zunaechst APIs und Felder unveraendert lassen.
4. **Fachmodule trennen:** Dashboard, Baustellen, Auftraege, Zeiterfassung, Mitarbeiter, Fotos und Einstellungen in passende Feature- oder Screen-Dateien verschieben; `main.dart` auf Initialisierung und Routing reduzieren.
5. **Repository-Vertrag einfuehren:** Pro Fachbereich minimale Schnittstellen fuer Lesen und Schreiben definieren. Zuerst kann eine In-Memory-Implementierung die bestehende Funktionalitaet erhalten.
6. **Persistenz entscheiden und testen:** Nach der Architekturentscheidung einen kleinen End-to-End-Fluss persistieren, zum Beispiel Baustelle anlegen, App neu starten und Baustelle wieder laden.
7. **Eingabeobjekte typisieren:** Datum und Uhrzeiten in geeignete Typen ueberfuehren oder zentral validieren; Statuswerte und Dropdown-Optionen als kontrollierte Werte modellieren.
8. **Responsive Navigation vervollstaendigen:** Einen ueberlaufenden oder sekundaren Navigationsweg fuer Fotos und Einstellungen auf Mobile definieren und mit einem Widget-Test absichern.

## Pruefstatus

- Quellcode und Projektregeln gelesen.
- Datenfluss von Navigation ueber `_Content` bis zu Formular-Callbacks verfolgt.
- Benachbarter Test `test/widget_test.dart` geprueft.
- `flutter analyze`: keine Fehler, ein Info-Hinweis bei `lib/main.dart:332` (`use_null_aware_elements`).
- `flutter test`: fehlgeschlagen, weil der veraltete Counter-Test kein Plus-Icon findet.
- Keine Anwendungsdateien geaendert; nur dieses Analyse-Artefakt wurde aktualisiert.