import 'package:flutter/material.dart';
import '../../services/time_tracking_service.dart';

class TimeEntryDialog extends StatefulWidget {
  final TimeTrackingService service;
  final List<dynamic> sites;

  const TimeEntryDialog({super.key, required this.service, required this.sites});

  @override
  State<TimeEntryDialog> createState() => _TimeEntryDialogState();
}

class _TimeEntryDialogState extends State<TimeEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProjectId;
  String _projectName = '';
  String _employeeName = 'Team Pincus';
  double _hours = 1.0;
  final DateTime _date = DateTime.now();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Arbeitsstunden erfassen'),
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
                  items: widget.sites.map<DropdownMenuItem<String>>((site) {
                    return DropdownMenuItem<String>(
                      value: site.id.toString(),
                      child: Text(site.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProjectId = val;
                      final site = widget.sites.firstWhere((s) => s.id.toString() == val, orElse: () => null);
                      if (site != null) {
                        _projectName = site.name;
                      }
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _selectedProjectId != null) {
              await widget.service.addTimeEntry(
                projectId: _selectedProjectId!,
                projectName: _projectName,
                employeeName: _employeeName,
                hours: _hours,
                date: _date,
                description: _descController.text,
              );
              if (!context.mounted) return;
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
