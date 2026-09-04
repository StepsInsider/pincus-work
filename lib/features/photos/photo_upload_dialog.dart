import 'package:flutter/material.dart';

import '../../services/photo_documentation_service.dart';
import '../sites/widgets/site_selector_widget.dart';
import 'models/photo_documentation.dart';

class PhotoUploadDialog extends StatefulWidget {
  const PhotoUploadDialog({
    super.key,
    required this.sites,
    required this.service,
    this.initialProjectId,
    this.onSaved,
  });

  final List<SiteSelectorItem> sites;
  final PhotoDocumentationService service;
  final String? initialProjectId;
  final ValueChanged<PhotoDocumentation>? onSaved;

  @override
  State<PhotoUploadDialog> createState() => _PhotoUploadDialogState();
}

class _PhotoUploadDialogState extends State<PhotoUploadDialog> {
  final _noteController = TextEditingController();
  late String? _selectedProjectId =
      widget.initialProjectId ??
      (widget.sites.isEmpty ? null : widget.sites.first.id);
  String _category = 'vorher';
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final projectId = _selectedProjectId;
    if (projectId == null) return;

    setState(() => _isLoading = true);
    try {
      final result = await widget.service.captureAndUploadDocumentation(
        projectId: projectId,
        note: _noteController.text,
        category: _category,
      );
      if (!mounted) return;
      if (result != null) {
        widget.onSaved?.call(result);
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Foto-Upload: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Baustellen-Foto erfassen'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SiteSelectorWidget(
                sites: widget.sites,
                selectedSiteId: _selectedProjectId,
                onSiteSelected: (id) => setState(() {
                  _selectedProjectId = id;
                }),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategorie *'),
                items: const [
                  DropdownMenuItem(value: 'vorher', child: Text('Vorher')),
                  DropdownMenuItem(value: 'nachher', child: Text('Nachher')),
                  DropdownMenuItem(
                    value: 'fortschritt',
                    child: Text('Fortschritt'),
                  ),
                ],
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                enabled: !_isLoading,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notiz / Beschreibung',
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
        FilledButton.icon(
          onPressed: _isLoading || _selectedProjectId == null ? null : _capture,
          icon: _isLoading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.camera_alt_outlined),
          label: const Text('Foto aufnehmen'),
        ),
      ],
    );
  }
}
