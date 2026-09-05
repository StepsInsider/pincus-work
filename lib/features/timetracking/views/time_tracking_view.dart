import 'package:flutter/material.dart';
import '../../../services/time_tracking_service.dart';
import '../time_entry_dialog.dart';

class TimeTrackingView extends StatefulWidget {
  final TimeTrackingService service;
  final List<dynamic> sites;

  const TimeTrackingView({super.key, required this.service, required this.sites});

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
                  const Text(
                    'Zeiterfassung',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
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
                    builder: (context) => TimeEntryDialog(
                      service: widget.service,
                      sites: widget.sites,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Stunden erfassen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                ),
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
                          trailing: Text(
                            '${entry.hours} Std.',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
