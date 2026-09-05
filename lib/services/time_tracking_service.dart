import 'package:flutter/foundation.dart';

class TimeEntry {
  final String id;
  final String projectId;
  final String projectName;
  final String employeeName;
  final double hours;
  final DateTime date;
  final String description;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.employeeName,
    required this.hours,
    required this.date,
    required this.description,
  });
}

class TimeTrackingService extends ChangeNotifier {
  final List<TimeEntry> _entries = [
    TimeEntry(
      id: '1',
      projectId: 'site-1',
      projectName: 'Baumschnitt Baustelle Hauptstraße',
      employeeName: 'Team Pincus',
      hours: 4.5,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Kroneneinkürzung und Totholzentfernung durchgeführt.',
    ),
  ];

  List<TimeEntry> get entries => List.unmodifiable(_entries);

  List<TimeEntry> entriesForProject(String projectId) {
    return _entries.where((e) => e.projectId == projectId).toList();
  }

  Future<void> addTimeEntry({
    required String projectId,
    required String projectName,
    required String employeeName,
    required double hours,
    required DateTime date,
    required String description,
  }) async {
    final newEntry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: projectId,
      projectName: projectName,
      employeeName: employeeName,
      hours: hours,
      date: date,
      description: description,
    );
    _entries.insert(0, newEntry);
    notifyListeners();
  }
}
