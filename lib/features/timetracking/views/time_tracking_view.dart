import 'package:flutter/material.dart';

import '../../../services/time_tracking_service.dart';
import '../repositories/time_entry_repository.dart';
import '../time_entry_dialog.dart';

class TimeTrackingView extends StatefulWidget {
  final TimeTrackingService service;
  final List<dynamic> sites;
  final TimeEntryRepository? repository;

  const TimeTrackingView({super.key, required this.service, required this.sites, this.repository});

  @override
  State<TimeTrackingView> createState() => _TimeTrackingViewState();
}

class _TimeTrackingViewState extends State<TimeTrackingView> {
  @override
  void initState() {
    super.initState();
    widget.service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    widget.service.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    setState(() {});
  }

  Future<void> _deleteEntry(TimeEntry entry) async {
    final repository = widget.repository;
    if (repository == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kein Zeit-Repository konfiguriert.')));
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zeiteintrag löschen?'),
        content: const Text('Der bestehende Zeiteintrag wird dauerhaft gelöscht.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await repository.deleteTimeEntry(entry.id);
      widget.service.removeTimeEntry(entry.id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Löschen fehlgeschlagen: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.service.entries;
    final totalHours = entries.fold(0.0, (sum, e) => sum + e.hours);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Zeiterfassung', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(
                    'Gesamtstunden: ${totalHours.toStringAsFixed(1)} Std.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        TimeEntryDialog(service: widget.service, sites: widget.sites, repository: widget.repository),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Stunden erfassen'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('Noch keine Zeiteinträge vorhanden.'))
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.timer, color: Colors.white),
                          ),
                          title: Text(entry.projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Mitarbeiter: ${entry.employeeName}\n${entry.description.isEmpty ? "Keine Beschreibung" : entry.description}\nDatum: ${entry.date.toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${entry.hours} Std.',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              IconButton(
                                tooltip: 'Bearbeiten',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => showDialog<void>(
                                  context: context,
                                  builder: (context) => TimeEntryDialog(
                                    service: widget.service,
                                    sites: widget.sites,
                                    initialEntry: entry,
                                    repository: widget.repository,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Löschen',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteEntry(entry),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
