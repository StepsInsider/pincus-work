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
}

typedef Site = SiteModel;
