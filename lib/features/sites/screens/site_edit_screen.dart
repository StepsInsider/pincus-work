import 'package:flutter/material.dart';

import '../models/site_model.dart';
import '../repositories/site_repository.dart';

class SiteEditScreen extends StatefulWidget {
  final SiteModel site;
  final SiteRepository repository;

  const SiteEditScreen({super.key, required this.site, required this.repository});

  @override
  State<SiteEditScreen> createState() => _SiteEditScreenState();
}

class _SiteEditScreenState extends State<SiteEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _customerController;
  late final TextEditingController _addressController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.site.name);
    _customerController = TextEditingController(text: widget.site.customer);
    _addressController = TextEditingController(text: widget.site.address);
    _selectedStatus = widget.site.status.isNotEmpty ? widget.site.status : 'In Ausführung';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = SiteModel(
      id: widget.site.id,
      name: _nameController.text.trim(),
      customer: _customerController.text.trim(),
      address: _addressController.text.trim(),
      status: _selectedStatus,
    );
    try {
      await widget.repository.updateSite(updated);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $error')));
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baustelle bearbeiten'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Baustellenname'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customerController,
              decoration: const InputDecoration(labelText: 'Kunde'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Beschreibung / Adresse'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: ['In Ausführung', 'Geplant', 'Abgeschlossen'].contains(_selectedStatus)
                  ? _selectedStatus
                  : 'In Ausführung',
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'In Ausführung', child: Text('In Ausführung')),
                DropdownMenuItem(value: 'Geplant', child: Text('Geplant')),
                DropdownMenuItem(value: 'Abgeschlossen', child: Text('Abgeschlossen')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedStatus = val);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Änderungen speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
