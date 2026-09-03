---
name: pincus-material-equipment
description: "Implementiert und prüft ein Material- und Geräteverwaltungsmodul pro Baustelle in Pincus Work mit Flutter und Supabase. Verwende diese Skill bei Materialerfassung, Maschinen- oder Werkzeugeinsatz, site_materials_equipment, Supabase-RLS oder projektbezogenen Verbrauchsbuchungen."
argument-hint: "Baustellen-ID und gewünschte Material-/Geräteerfassung angeben"
---

# Material- und Geräteverwaltung

Diese Skill führt die Einführung einer Erfassung für verbrauchtes Material sowie den Einsatz von Geräten und Maschinen je Baustelle durch. Die Daten sollen über Supabase persistiert und in der Flutter-Oberfläche erfasst und angezeigt werden.

## Voraussetzungen prüfen

1. Lies zuerst die bestehenden Anweisungen für Flutter, UI und Tests.
2. Prüfe die aktuelle Baustellenstruktur: Model, Repository, ID-Typ, Navigation und bestehende Detailansicht.
3. Prüfe `pubspec.yaml` auf `supabase_flutter` und die vorhandene Supabase-Initialisierung.
4. Prüfe, ob `lib/services/` bereits als Service-Schicht verwendet wird. Bevorzuge vorhandene Repository-Grenzen, falls sie etabliert sind.
5. Prüfe, ob bereits eine Tabelle oder Migration für Material- und Gerätedaten existiert.

Wenn Supabase noch nicht eingerichtet ist, implementiere keine halbaktive Produktivintegration. Dokumentiere die fehlenden Zugangsdaten, Initialisierung oder Migration und wähle entweder eine klar markierte Vorbereitungsänderung oder frage nach der gewünschten Integrationsstufe.

## Datenvertrag festlegen

Verwende für die Tabelle `public.site_materials_equipment` mindestens diese Felder:

- `id`: UUID, Primärschlüssel, automatisch erzeugt
- `project_id`: nicht-null Baustellen-ID; muss zum vorhandenen ID-Typ passen
- `item_name`: nicht-null Bezeichnung
- `type`: `material` oder `geraet`
- `quantity`: nicht-negative Zahl
- `unit`: nicht-leere Einheit
- `notes`: optionaler Text
- `created_at`: UTC-Zeitstempel

Vor der Migration klären:

- Ob `project_id` als `text` oder als Fremdschlüssel auf das Baustellenmodell angelegt werden muss.
- Ob Einträge nach dem Erstellen bearbeitet oder gelöscht werden dürfen.
- Ob die Daten nur authentifizierte Benutzer sehen und ändern dürfen oder zusätzlich baustellenbezogene Policies benötigen.
- Ob Einheiten und Kategorien feste Werte bleiben oder später konfigurierbar werden.

Die SQL-Migration muss idempotent ausführbar sein, Constraints für `type` und sinnvolle Mengenvalidierung enthalten und Row Level Security aktivieren. Eine pauschale Policy für alle authentifizierten Benutzer ist nur zulässig, wenn sie zur bestehenden Autorisierung passt; andernfalls die engere Baustellen-Policy verwenden.

## Service und Datenfluss

1. Lege den Zugriff in einer eigenen Service- oder Repository-Datei ab, nicht im Widget.
2. Implementiere eine Schreiboperation mit benannten Pflichtparametern für Baustelle, Bezeichnung, Kategorie, Menge und Einheit sowie optionalen Notizen.
3. Validierung und Parsing müssen vor dem Supabase-Aufruf erfolgen. Ungültige, negative oder nicht endliche Mengen dürfen nicht gespeichert werden.
4. Übernimm Zeitstempel und Sortierung aus dem Datenmodell konsistent; verlasse dich bei konkurrierenden Clients möglichst auf den Datenbank-Default.
5. Implementiere den Abruf der Einträge für eine Baustelle. Nutze einen Stream nur, wenn Realtime für die Tabelle eingerichtet ist und die Oberfläche ihn benötigt; sonst genügt ein gezielter Abruf.
6. Konvertiere Supabase-Ergebnisse an einer klaren Grenze in ein Dart-Model, wenn im Projekt Models und Repositories bereits getrennt sind.
7. Behandle Authentifizierungs-, Netzwerk- und Datenbankfehler so, dass die UI eine verständliche Rückmeldung erhält und der Ladezustand beendet wird.

## Erfassungsdialog

Baue unter `lib/features/materials/` eine responsive Material-3-Eingabemaske oder einen Dialog mit:

- Kategorie: Material oder Gerät/Maschine
- Bezeichnung
- Menge/Anzahl
- Einheit, mindestens Stück, Sack, Stunden, kg und m², sofern diese Einheiten fachlich passen
- optionale Notizen
- Abbrechen und Speichern

Verwende `TextEditingController` nur mit sauberem Lifecycle. Der Speichern-Button ist während des Schreibvorgangs deaktiviert und zeigt einen passenden Ladezustand. Nach Erfolg wird der Dialog geschlossen und die Liste aktualisiert. Nach Fehler bleibt der Dialog offen, zeigt eine verständliche Meldung und lässt erneutes Speichern zu.

Die Eingabemaske muss:

- leere Bezeichnungen und Einheiten ablehnen
- Mengen robust mit deutscher oder projektweit festgelegter Dezimalnotation behandeln
- keine `double.parse`-Exception bis zur Benutzeroberfläche durchreichen
- `mounted` vor Zustandsänderungen nach `await` prüfen
- auf schmalen mobilen Breiten ohne Überlauf funktionieren

## Integration in Baustellen

1. Platziere die Funktion in der bestehenden Baustellen-Detailansicht oder dem dafür vorgesehenen Modulbereich.
2. Übergib die echte Baustellen-ID aus dem vorhandenen Model; erzeuge keine neue parallele ID-Quelle.
3. Zeige Einträge getrennt oder filterbar nach Material und Gerät und sortiere neue Einträge nachvollziehbar.
4. Berücksichtige Lade-, Leer-, Fehler- und Aktualisierungszustände.
5. Erhalte Desktop-Navigation, Mobile-Navigation und die bestehende Pincus-Oberfläche.

## Tests und Abschlussprüfung

Ergänze fokussierte Tests für:

- Pflichtfeld- und Mengenvalidierung
- erfolgreiche Speicherung mit korrektem Datenpayload, falls der Zugriff injizierbar ist
- Fehlerverhalten und Zurücksetzen des Ladezustands
- Darstellung von Lade-, Leer- und gefülltem Zustand
- Nutzung der korrekten Baustellen-ID

Führe anschließend in dieser Reihenfolge aus:

1. `dart format .`
2. `flutter analyze`
3. relevante Tests mit `flutter test`
4. bei Web-relevanten Änderungen `flutter build web --release`

Prüfe abschließend, dass keine unnötige Abhängigkeit hinzugefügt wurde, keine bestehende Baustellenfunktion verloren ging und die SQL-Migration sowie RLS-Policies dokumentiert und reproduzierbar sind.
