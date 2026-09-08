import 'package:flutter/material.dart';

import '../../customers/repositories/customer_repository.dart';
import '../models/site_model.dart';
import '../widgets/customer_edit_dialog.dart';

class BaustellenDetailScreen extends StatefulWidget {
  const BaustellenDetailScreen({super.key, required this.site, required this.onSiteUpdated, this.customerRepository});

  final SiteModel site;
  final ValueChanged<SiteModel> onSiteUpdated;
  final CustomerRepository? customerRepository;

  @override
  State<BaustellenDetailScreen> createState() => _BaustellenDetailScreenState();
}

class _BaustellenDetailScreenState extends State<BaustellenDetailScreen> {
  late SiteModel _site;

  @override
  void initState() {
    super.initState();
    _site = widget.site;
  }

  Future<void> _editCustomer() async {
    final updatedSite = await showDialog<SiteModel>(
      context: context,
      builder: (context) => KundenEditDialog(site: _site, repository: widget.customerRepository),
    );
    if (!mounted || updatedSite == null) return;
    setState(() => _site = updatedSite);
    widget.onSiteUpdated(updatedSite);
  }

  Future<void> _deleteCustomer() async {
    final customerId = _site.customerId;
    final repository = widget.customerRepository;
    if (repository == null || customerId == null || customerId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kunde löschen?'),
        content: Text('Der Kunde "${_site.customer}" wird dauerhaft gelöscht.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await repository.deleteCustomer(customerId);
      if (!mounted) return;
      final updatedSite = _site.copyWith(customer: '', address: '', contactPerson: '', phone: '');
      setState(() => _site = updatedSite);
      widget.onSiteUpdated(updatedSite);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Löschen fehlgeschlagen: $error')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_site.name),
      actions: [
        if (widget.customerRepository != null && _site.customerId != null)
          IconButton(onPressed: _deleteCustomer, tooltip: 'Kunde löschen', icon: const Icon(Icons.delete_outline)),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(_site.status, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Kundeninformationen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      onPressed: _editCustomer,
                      tooltip: 'Kundendaten bearbeiten',
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                const Divider(),
                _DetailRow(icon: Icons.business_outlined, label: 'Kunde', value: _site.customer),
                _DetailRow(icon: Icons.location_on_outlined, label: 'Adresse', value: _site.address),
                if (_site.contactPerson.isNotEmpty)
                  _DetailRow(icon: Icons.person_outline, label: 'Ansprechpartner', value: _site.contactPerson),
                if (_site.phone.isNotEmpty)
                  _DetailRow(icon: Icons.phone_outlined, label: 'Telefon', value: _site.phone),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              Text(value),
            ],
          ),
        ),
      ],
    ),
  );
}
