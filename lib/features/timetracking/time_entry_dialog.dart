import 'package:flutter/material.dart';

import '../../services/time_tracking_service.dart';
import 'repositories/time_entry_repository.dart';

class TimeEntryDialog extends StatefulWidget {
  final TimeTrackingService service;
  final List<dynamic> sites;
  final TimeEntry? initialEntry;
  final TimeEntryRepository? repository;

  const TimeEntryDialog({super.key, required this.service, required this.sites, this.initialEntry, this.repository});

  @override
  State<TimeEntryDialog> createState() => _TimeEntryDialogState();
}

class _TimeEntryDialogState extends State<TimeEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProjectId;
  String _projectName = '';
  String _employeeName = 'Team Pincus';
  double _hours = 1.0;
  late DateTime _date;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _selectedProjectId = entry?.projectId;
    _projectName = entry?.projectName ?? '';
    _employeeName = entry?.employeeName ?? 'Team Pincus';
    _hours = entry?.hours ?? 1.0;
    _date = entry?.date ?? DateTime.now();
    _descController = TextEditingController(text: entry?.description);
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialEntry == null ? 'Arbeitsstunden erfassen' : 'Zeiteintrag bearbeiten'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Baustelle / Projekt'),
                  initialValue: _selectedProjectId,
                  items: widget.sites.map<DropdownMenuItem<String>>((site) {
                    return DropdownMenuItem<String>(value: site.id.toString(), child: Text(site.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProjectId = val;
                      final selected = widget.sites.where((s) => s.id.toString() == val).firstOrNull;
                      _projectName = selected?.name ?? _projectName;
                    });
                  },
                  validator: (val) => val == null ? 'Bitte Baustelle wählen' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _employeeName,
                  decoration: const InputDecoration(labelText: 'Mitarbeiter / Team'),
                  onChanged: (val) => _employeeName = val,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _hours.toString(),
                  decoration: const InputDecoration(labelText: 'Stunden'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || double.tryParse(val) == null) return 'Gültige Stundenzahl eingeben';
                    return null;
                  },
                  onChanged: (val) => _hours = double.tryParse(val) ?? 1.0,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Beschreibung / Tätigkeiten'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _selectedProjectId != null) {
              try {
                final existing = widget.initialEntry;
                if (existing == null) {
                  if (widget.repository != null) {
                    final created = await widget.repository!.addTimeEntry(
                      projectId: _selectedProjectId!,
                      projectName: _projectName,
                      employeeName: _employeeName,
                      hours: _hours,
                      date: _date,
                      description: _descController.text,
                    );
                    widget.service.entriesInsertOrAdd(created);
                  } else {
                    await widget.service.addTimeEntry(
                      projectId: _selectedProjectId!,
                      projectName: _projectName,
                      employeeName: _employeeName,
                      hours: _hours,
                      date: _date,
                      description: _descController.text,
                    );
                  }
                } else {
                  final updated = TimeEntry(
                    id: existing.id,
                    projectId: _selectedProjectId!,
                    projectName: _projectName,
                    employeeName: _employeeName,
                    hours: _hours,
                    date: _date,
                    description: _descController.text,
                  );
                  if (widget.repository != null) await widget.repository!.updateTimeEntry(updated);
                  await widget.service.updateTimeEntry(updated);
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $error')));
              }
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
