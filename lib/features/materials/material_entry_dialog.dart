import 'package:flutter/material.dart';

import '../../services/material_equipment_service.dart';

class MaterialEntryDialog extends StatefulWidget {
  const MaterialEntryDialog({
    super.key,
    required this.projectId,
    required this.service,
    this.onSaved,
  });

  final String projectId;
  final MaterialEquipmentService service;
  final VoidCallback? onSaved;

  @override
  State<MaterialEntryDialog> createState() => _MaterialEntryDialogState();
}

class _MaterialEntryDialogState extends State<MaterialEntryDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  String _type = 'material';
  String _unit = 'Stück';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final quantity = double.tryParse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );
    if (_nameController.text.trim().isEmpty ||
        quantity == null ||
        !quantity.isFinite ||
        quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte Bezeichnung und eine gültige Menge angeben.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.service.logUsage(
        projectId: widget.projectId,
        itemName: _nameController.text,
        type: _type,
        quantity: quantity,
        unit: _unit,
        notes: _notesController.text,
      );
      widget.onSaved?.call();
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Material / Gerät erfassen'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Kategorie *'),
                items: const [
                  DropdownMenuItem(
                    value: 'material',
                    child: Text('Material (Verbrauch)'),
                  ),
                  DropdownMenuItem(
                    value: 'geraet',
                    child: Text('Gerät / Maschine (Einsatz)'),
                  ),
                ],
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _type = value ?? _type),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Bezeichnung *',
                  hintText: 'z. B. Rindenmulch oder Bagger',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityController,
                      enabled: !_isLoading,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Menge *'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _unit,
                      decoration: const InputDecoration(labelText: 'Einheit *'),
                      items: const [
                        DropdownMenuItem(value: 'Stück', child: Text('Stück')),
                        DropdownMenuItem(value: 'Sack', child: Text('Sack')),
                        DropdownMenuItem(value: 'Std', child: Text('Std')),
                        DropdownMenuItem(value: 'kg', child: Text('kg')),
                        DropdownMenuItem(value: 'm²', child: Text('m²')),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (value) => setState(() => _unit = value ?? _unit),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                enabled: !_isLoading,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notizen (optional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Speichern'),
        ),
      ],
    );
  }
}
