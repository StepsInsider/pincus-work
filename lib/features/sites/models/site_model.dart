class SiteModel {
  final String id;
  final String? customerId;
  final String name;
  final String customer;
  final String address;
  final String status;
  final String contactPerson;
  final String phone;

  SiteModel({
    required this.id,
    this.customerId,
    required this.name,
    required this.customer,
    required this.address,
    required this.status,
    this.contactPerson = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'customer': customer,
    'address': address,
    'status': status,
    'contact_person': contactPerson,
    'phone': phone,
    if (customerId != null) 'customer_id': customerId,
  };

  factory SiteModel.fromMap(Map<String, dynamic> map) => SiteModel(
    id: map['id'].toString(),
    customerId: map['customer_id']?.toString(),
    name: map['name'] as String? ?? '',
    customer: map['customer'] as String? ?? '',
    address: map['address'] as String? ?? '',
    status: map['status'] as String? ?? '',
    contactPerson: map['contact_person'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
  );

  SiteModel copyWith({
    String? name,
    String? customer,
    String? address,
    String? status,
    String? contactPerson,
    String? phone,
    String? customerId,
  }) => SiteModel(
    id: id,
    customerId: customerId ?? this.customerId,
    name: name ?? this.name,
    customer: customer ?? this.customer,
    address: address ?? this.address,
    status: status ?? this.status,
    contactPerson: contactPerson ?? this.contactPerson,
    phone: phone ?? this.phone,
  );
}

typedef Site = SiteModel;
