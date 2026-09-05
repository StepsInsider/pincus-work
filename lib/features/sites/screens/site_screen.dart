import 'package:flutter/material.dart';
import '../repositories/site_repository.dart';
import '../models/site_model.dart';
import 'site_edit_screen.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  final SiteRepository _repository = SiteRepository();

  void _openEdit(SiteModel site) async {
    final updated = await Navigator.of(context).push<SiteModel>(
      MaterialPageRoute(
        builder: (context) => SiteEditScreen(
          site: site,
          repository: _repository,
        ),
      ),
    );
    if (updated != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final sites = _repository.getSites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Baustellen'),
        backgroundColor: const Color(0xFF23863A),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final SiteModel site = sites[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Color(0xFFE2E7E2)),
            ),
            child: ListTile(
              onTap: () => _openEdit(site),
              title: Text(
                site.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${site.customer} • ${site.address}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(site.status, style: const TextStyle(fontSize: 12)),
                    backgroundColor: const Color(0xFFEAF5EC),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
