import '../models/site_model.dart';

class SiteRepository {
  final List<SiteModel> _sites = [
    // Ursprüngliche Einträge
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
    // Neue Kunden & Baustellen (Import)
    SiteModel(
      id: '3',
      name: 'Apleona Wickede',
      customer: 'Apleona Wickede',
      address: 'Wickede (Allgemeine Außenanlagen / Baumpflege / Instandhaltung)',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '4',
      name: 'Beim Papst',
      customer: 'Beim Papst',
      address: 'Objekt- oder Gartenpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '5',
      name: 'Bochefski',
      customer: 'Bochefski',
      address: 'Garten- und Landschaftsbau / Objektpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '6',
      name: 'Dorstfeld',
      customer: 'Dorstfeld',
      address: 'Baumaßnahme / Grünpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '7',
      name: 'Halle (Firmengelände / Lager)',
      customer: 'Halle',
      address: 'Firmenbasis, Materiallager, Hofbereich',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '8',
      name: 'Hellman',
      customer: 'Hellman',
      address: 'Hecken- und Grünpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '9',
      name: 'Huckarde',
      customer: 'Huckarde',
      address: 'Baumaßnahme / Grünpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '10',
      name: 'Kirchhörde',
      customer: 'Kirchhörde',
      address: 'Umfassende Garten- und Landschaftsbauarbeiten, Pflasterarbeiten',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '11',
      name: 'Lindenallee',
      customer: 'Lindenallee',
      address: 'Straßen- oder Baumpflegearbeiten',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '12',
      name: 'Lünen',
      customer: 'Lünen',
      address: 'Baumaßnahme / Pflegeobjekt',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '13',
      name: 'Lünen Gahmen',
      customer: 'Lünen Gahmen',
      address: 'Hecken- und Grundstückspflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '14',
      name: 'Maiwald',
      customer: 'Maiwald',
      address: 'Heckenschnitt',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '15',
      name: 'Mengede / Mengede Worderfeld',
      customer: 'Mengede',
      address: 'Außenanlagen / Erdarbeiten',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '16',
      name: 'Mohring',
      customer: 'Mohring',
      address: 'Schotter- und Erdarbeiten, Wegebau',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '17',
      name: 'Peter Unger',
      customer: 'Peter Unger',
      address: 'Hecken- und Baumpflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '18',
      name: 'Sportzentrum',
      customer: 'Sportzentrum',
      address: 'Großflächige Pflege- und Instandsetzungsarbeiten',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '19',
      name: 'Stein (Unna)',
      customer: 'Stein',
      address: 'Heckenschnitt / Gartenpflege (Unna)',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '20',
      name: 'Wiegmann',
      customer: 'Wiegmann',
      address: 'Grün- und Heckenschnitt',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '21',
      name: 'Festtag Wickede',
      customer: 'Festtag Wickede',
      address: 'Regelmäßige Pflege- und Wegebauarbeiten',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '22',
      name: 'Baustelle "Am Fuchsbau"',
      customer: 'Am Fuchsbau',
      address: 'Hauptbaustelle (Erdarbeiten, Abwasserrohre, Bitumenvoranstrich, Pflasterarbeiten, Zaunbau)',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '23',
      name: 'Dreher (Objekt 63 / 112)',
      customer: 'Dreher',
      address: 'Unbeseitigung, Rindenmulch verteilen, Gartenpflege (Beschwerde-Objekt)',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '24',
      name: 'Werner',
      customer: 'Werner',
      address: 'Hecken- und Grundstückspflege',
      status: 'In Ausführung',
    ),
    SiteModel(
      id: '25',
      name: 'Bergkamen (Altenheim)',
      customer: 'Bergkamen Altenheim',
      address: 'Heckenschnitt und Außenanlagenpflege',
      status: 'In Ausführung',
    ),
  ];

  List<SiteModel> getSites() => List.unmodifiable(_sites);
  void addSite(SiteModel site) {
    _sites.add(site);
  }
}
