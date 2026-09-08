class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPerson,
    required this.phone,
  });

  final String id;
  final String name;
  final String address;
  final String contactPerson;
  final String phone;

  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'contact_person': contactPerson,
    'phone': phone,
  };

  factory CustomerModel.fromMap(Map<String, dynamic> map) => CustomerModel(
    id: map['id'].toString(),
    name: map['name'] as String? ?? '',
    address: map['address'] as String? ?? '',
    contactPerson: map['contact_person'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
  );
}
