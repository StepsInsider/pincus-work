import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/customer_model.dart';

class CustomerRepository extends ChangeNotifier {
  CustomerRepository([this._client]);

  final SupabaseClient? _client;
  final List<CustomerModel> _customers = [];

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  List<CustomerModel> get customers => List.unmodifiable(_customers);

  Future<CustomerModel?> customerById(String id) async {
    _requireAuthenticated();
    final rows = await _supabase.from('customers').select().eq('id', id).limit(1);
    if (rows.isEmpty) return null;
    final customer = CustomerModel.fromMap(Map<String, dynamic>.from(rows.first));
    _replace(customer);
    notifyListeners();
    return customer;
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    _requireAuthenticated();
    await _supabase.from('customers').update(customer.toMap()).eq('id', customer.id);
    _replace(customer);
    notifyListeners();
  }

  Future<String> createCustomer({
    required String name,
    required String address,
    required String contactPerson,
    required String phone,
  }) async {
    _requireAuthenticated();
    final response = await _supabase
        .from('customers')
        .insert({'name': name, 'address': address, 'contact_person': contactPerson, 'phone': phone})
        .select('id')
        .single();
    final id = response['id'].toString();
    _replace(CustomerModel(id: id, name: name, address: address, contactPerson: contactPerson, phone: phone));
    notifyListeners();
    return id;
  }

  Future<void> deleteCustomer(String id) async {
    _requireAuthenticated();
    await _supabase.from('customers').delete().eq('id', id);
    _customers.removeWhere((customer) => customer.id == id);
    notifyListeners();
  }

  void _replace(CustomerModel customer) {
    final index = _customers.indexWhere((item) => item.id == customer.id);
    if (index == -1) {
      _customers.add(customer);
    } else {
      _customers[index] = customer;
    }
  }

  void _requireAuthenticated() {
    if (_supabase.auth.currentUser == null) {
      throw StateError('Kunden können nur von authentifizierten Benutzern geändert werden.');
    }
  }
}
