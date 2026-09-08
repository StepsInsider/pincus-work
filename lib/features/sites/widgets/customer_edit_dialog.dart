import 'package:flutter/material.dart';

import '../../customers/models/customer_model.dart';
import '../../customers/repositories/customer_repository.dart';
import '../models/site_model.dart';

class KundenEditDialog extends StatefulWidget {
  const KundenEditDialog({super.key, required this.site, this.repository});

  final SiteModel site;
  final CustomerRepository? repository;

  @override
  State<KundenEditDialog> createState() => _KundenEditDialogState();
}

class _KundenEditDialogState extends State<KundenEditDialog> {
  late final TextEditingController _customerController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(text: widget.site.customer);
    _addressController = TextEditingController(text: widget.site.address);
    _contactController = TextEditingController(text: widget.site.contactPerson);
    _phoneController = TextEditingController(text: widget.site.phone);
  }

  @override
  void dispose() {
    _customerController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final customerName = _customerController.text.trim();
    if (customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bitte einen Kundennamen eingeben.')));
      return;
    }

    var customerId = widget.site.customerId;
    final address = _addressController.text.trim();
    final contactPerson = _contactController.text.trim();
    final phone = _phoneController.text.trim();

    if (widget.repository != null) {
      try {
        if (customerId == null || customerId.isEmpty) {
          customerId = await widget.repository!.createCustomer(
            name: customerName,
            address: address,
            contactPerson: contactPerson,
            phone: phone,
          );
        } else {
          await widget.repository!.updateCustomer(
            CustomerModel(
              id: customerId,
              name: customerName,
              address: address,
              contactPerson: contactPerson,
              phone: phone,
            ),
          );
        }
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $error')));
        return;
      }
    }

    final updatedSite = widget.site.copyWith(
      customer: customerName,
      address: address,
      contactPerson: contactPerson,
      phone: phone,
      customerId: customerId,
    );

    if (!mounted) return;
    Navigator.of(context).pop(updatedSite);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Kundendaten bearbeiten'),
    content: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _customerController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Kunde *', prefixIcon: Icon(Icons.business_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adresse', prefixIcon: Icon(Icons.location_on_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Ansprechpartner', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefonnummer', prefixIcon: Icon(Icons.phone_outlined)),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
      FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined), label: const Text('Speichern')),
    ],
  );
}
