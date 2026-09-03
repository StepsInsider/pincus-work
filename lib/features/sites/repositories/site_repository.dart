import '../models/site_model.dart';

class SiteRepository {
  final List<SiteModel> _sites = [
    SiteModel(
      id: '1',
      name: 'Gartenneugestaltung Dortmund',
      customer: 'Stadt Dortmund',
      address: 'Hospitalstraße 2',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '2',
      name: 'Baumpflege Kamen',
      customer: 'Privatkunden',
      address: 'Kamen Zentrum',
      status: 'Geplant',
    ),
  ];

  List<SiteModel> getSites() => List.unmodifiable(_sites);
  void addSite(SiteModel site) {
    _sites.add(site);
  }
}
