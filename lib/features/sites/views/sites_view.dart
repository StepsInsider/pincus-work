import 'package:flutter/material.dart';
import '../models/site_model.dart';

class SitesView extends StatelessWidget {
  final List<Site> sites;
  final Function(Site) onAddSite;

  const SitesView({super.key, required this.sites, required this.onAddSite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Baustellenverwaltung',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17672B),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF23863A),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final newSite = Site(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: 'Neue Baustelle ${sites.length + 1}',
                    customer: 'Kunde Beispiel',
                    address: 'Musterstraße 123, Dortmund',
                    status: 'Geplant',
                  );
                  onAddSite(newSite);
                },
                icon: const Icon(Icons.add),
                label: const Text('Baustelle anlegen'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sites.isEmpty
                ? const Center(child: Text('Keine Baustellen vorhanden.'))
                : ListView.builder(
                    itemCount: sites.length,
                    itemBuilder: (context, index) {
                      final site = sites[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E7E2)),
                        ),
                        color: const Color(0xFFF7F8F6),
                        child: ListTile(
                          title: Text(
                            site.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${site.customer} • ${site.address}'),
                          trailing: Chip(
                            label: Text(site.status),
                            backgroundColor: const Color(0xFFEAF5EC),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
