import 'package:flutter/material.dart';
import '../../../main.dart' show Site;
import '../../sites/widgets/site_selector_widget.dart';
import '../services/material_equipment_service.dart';

class MaterialsView extends StatefulWidget {
  const MaterialsView({
    super.key,
    required this.sites,
    required this.service,
    required this.onChanged,
  });

  final List<Site> sites;
  final MaterialEquipmentService service;
  final VoidCallback onChanged;

  @override
  State<MaterialsView> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends State<MaterialsView> {
  String? _selectedProjectId;

  @override
  Widget build(BuildContext context) {
    final selectedProjectId =
        widget.sites.any((site) => site.id == _selectedProjectId)
        ? _selectedProjectId
        : widget.sites.isEmpty
        ? null
        : widget.sites.first.id;
    final items = widget.sites
        .expand((site) => widget.service.itemsForProject(site.id))
        .toList();

    return Column(
      children: [
        if (widget.sites.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 360,
                child: SiteSelectorWidget(
                  sites: widget.sites
                      .map(
                        (site) => SiteSelectorItem(
                          id: site.id,
                          name: site.name,
                          status: site.status,
                        ),
                      )
                      .toList(),
                  selectedSiteId: selectedProjectId,
                  onSiteSelected: (value) => setState(() {
                    _selectedProjectId = value;
                  }),
                ),
              ),
            ),
          ),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text('Noch keine Material- oder Geräteeinträge.'),
                )
              : ListView(
                  children: items.map((item) {
                    final site = widget.sites.firstWhere(
                      (site) => site.id == item.projectId,
                      orElse: () => widget.sites.first,
                    );
                    return ListTile(
                      leading: Icon(
                        item.isEquipment
                            ? Icons.handyman_outlined
                            : Icons.inventory_2_outlined,
                      ),
                      title: Text(item.itemName),
                      subtitle: Text(
                        '${site.name} · ${item.quantity} ${item.unit}'
                        '${item.notes.isEmpty ? '' : ' · ${item.notes}'}',
                      ),
                      trailing: Chip(
                        label: Text(item.isEquipment ? 'Gerät' : 'Material'),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
