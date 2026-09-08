import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/time_tracking_service.dart';

class TimeEntryRepository extends ChangeNotifier {
  TimeEntryRepository([this._client]);

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<TimeEntry> addTimeEntry({
    required String projectId,
    required String projectName,
    required String employeeName,
    required double hours,
    required DateTime date,
    required String description,
  }) async {
    _requireAuthenticated();
    final response = await _supabase
        .from('time_entries')
        .insert({
          'project_id': projectId,
          'project_name': projectName,
          'employee_name': employeeName,
          'hours': hours,
          'date': date.toUtc().toIso8601String(),
          'description': description,
        })
        .select()
        .single();

    notifyListeners();
    return TimeEntry(
      id: response['id'].toString(),
      projectId: response['project_id'].toString(),
      projectName: response['project_name'] ?? projectName,
      employeeName: response['employee_name'] ?? employeeName,
      hours: (response['hours'] as num).toDouble(),
      date: DateTime.parse(response['date']),
      description: response['description'] ?? '',
    );
  }

  Future<void> updateTimeEntry(TimeEntry entry) async {
    _requireAuthenticated();
    await _supabase.from('time_entries').update(entry.toMap()).eq('id', entry.id);
    notifyListeners();
  }

  Future<void> updateTimeEntryData({required String id, required Map<String, dynamic> values}) async {
    _requireAuthenticated();
    await _supabase.from('time_entries').update(values).eq('id', id);
    notifyListeners();
  }

  Future<void> deleteTimeEntry(String id) async {
    _requireAuthenticated();
    await _supabase.from('time_entries').delete().eq('id', id);
    notifyListeners();
  }

  void _requireAuthenticated() {
    if (_supabase.auth.currentUser == null) {
      throw StateError('Zeiteinträge können nur von authentifizierten Benutzern geändert werden.');
    }
  }
}
