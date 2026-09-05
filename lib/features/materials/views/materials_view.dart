import "../../sites/models/site_model.dart";
import 'package:flutter/material.dart';
import '../../sites/widgets/site_selector_widget.dart';
import '../../../services/material_equipment_service.dart';
import '../material_entry_dialog.dart';

class MaterialsView extends StatefulWidget {
  const MaterialsView({
    super.key,
    required this.sites,
    required this.service,
    required this.onChanged,
  });

  final List<SiteModel> sites;
  final MaterialEquipmentService service;
  final VoidCallback onChanged;

  @override
  State<MaterialsView> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends State<MaterialsView> {
  String? _selectedProjectId;

  void _openAddDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => MaterialEntryDialog(
        projectId: projectId,
        service: widget.service,
        onSaved: () {
          setState(() {});
          widget.onChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProjectId =
        widget.sites.any((site) => site.id == _selectedProjectId)
            ? _selectedProjectId
            : widget.sites.isEmpty
            ? null
            : widget.sites.first.id;

    final items = selectedProjectId != null
        ? widget.service.itemsForProject(selectedProjectId)
        : widget.sites
            .expand((site) => widget.service.itemsForProject(site.id))
            .toList();

    return Scaffold(
      body: Column(
        children: [
          if (widget.sites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
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
                  const SizedBox(width: 16),
                  if (selectedProjectId != null)
                    FilledButton.icon(
                      onPressed: () => _openAddDialog(context, selectedProjectId),
                      icon: const Icon(Icons.add),
                      label: const Text('Material / Gerät erfassen'),
                    ),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Noch keine Material- oder Geräteeinträge.'),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
