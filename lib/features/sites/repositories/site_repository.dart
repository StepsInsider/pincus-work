import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/site_model.dart';

class SiteRepository extends ChangeNotifier {
  SiteRepository([this._client]);

  final SupabaseClient? _client;
  final List<SiteModel> _sites = [];

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  List<SiteModel> get sites => List.unmodifiable(_sites);

  Future<void> fetchSites() async {
    _requireAuthenticated();
    final response = await _supabase.from('sites').select();
    _sites.clear();
    for (final row in response) {
      _sites.add(SiteModel.fromMap(Map<String, dynamic>.from(row)));
    }
    notifyListeners();
  }

  Future<void> addSite(SiteModel site) async {
    _requireAuthenticated();
    final response = await _supabase.from('sites').insert(site.toMap()).select().single();
    final newSite = SiteModel.fromMap(Map<String, dynamic>.from(response));
    _sites.add(newSite);
    notifyListeners();
  }

  Future<void> updateSite(SiteModel updatedSite) async {
    _requireAuthenticated();
    await _supabase.from('sites').update(updatedSite.toMap()).eq('id', updatedSite.id);

    final index = _sites.indexWhere((s) => s.id == updatedSite.id);
    if (index != -1) {
      _sites[index] = updatedSite;
    } else {
      _sites.add(updatedSite);
    }
    notifyListeners();
  }

  Future<void> deleteSite(String id) async {
    _requireAuthenticated();
    await _supabase.from('sites').delete().eq('id', id);
    _sites.removeWhere((site) => site.id == id);
    notifyListeners();
  }

  void _requireAuthenticated() {
    if (_supabase.auth.currentUser == null) {
      throw StateError('Baustellen können nur von authentifizierten Benutzern bearbeitet werden.');
    }
  }
}
