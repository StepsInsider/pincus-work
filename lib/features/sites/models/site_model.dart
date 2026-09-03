class SiteModel {
  final String id;
  final String name;
  final String customer;
  final String address;
  final String status;

  SiteModel({
    required this.id,
    required this.name,
    required this.customer,
    required this.address,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customer': customer,
    'address': address,
    'status': status,
  };

  factory SiteModel.fromJson(Map<String, dynamic> json) => SiteModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    customer: json['customer'] ?? '',
    address: json['address'] ?? '',
    status: json['status'] ?? 'Geplant',
  );
}
