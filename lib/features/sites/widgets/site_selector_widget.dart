import 'package:flutter/material.dart';

class SiteSelectorItem {
  const SiteSelectorItem({
    required this.id,
    required this.name,
    required this.status,
  });

  final String id;
  final String name;
  final String status;
}

class SiteSelectorWidget extends StatefulWidget {
  const SiteSelectorWidget({
    super.key,
    required this.sites,
    required this.onSiteSelected,
    this.selectedSiteId,
  });

  final List<SiteSelectorItem> sites;
  final ValueChanged<String?> onSiteSelected;
  final String? selectedSiteId;

  @override
  State<SiteSelectorWidget> createState() => _SiteSelectorWidgetState();
}

class _SiteSelectorWidgetState extends State<SiteSelectorWidget> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sites.isEmpty) {
      return const Text('Keine Baustellen gefunden. Bitte zuerst eine Baustelle anlegen.');
    }

    final filteredSites = widget.sites.where((site) {
      final term = _searchTerm.toLowerCase();
      return term.isEmpty ||
          site.name.toLowerCase().contains(term) ||
          site.status.toLowerCase().contains(term);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.sites.length > 5) ...[
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Baustelle suchen',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _searchTerm = value.trim()),
          ),
          const SizedBox(height: 12),
        ],
        DropdownButtonFormField<String>(
          initialValue: filteredSites.any(
            (site) => site.id == widget.selectedSiteId,
          )
              ? widget.selectedSiteId
              : null,
          decoration: const InputDecoration(
            labelText: 'Aktive Baustelle auswählen *',
            prefixIcon: Icon(Icons.location_pin),
          ),
          items: filteredSites
              .map(
                (site) => DropdownMenuItem<String>(
                  value: site.id,
                  child: Text('${site.name} (${site.status})'),
                ),
              )
              .toList(),
          onChanged: widget.onSiteSelected,
        ),
        if (filteredSites.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Keine passende Baustelle gefunden.'),
          ),
      ],
    );
  }
}
