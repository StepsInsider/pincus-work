import '../features/materials/models/material_equipment_item.dart';

class MaterialEquipmentService {
  final List<MaterialEquipmentItem> _items = [];

  List<MaterialEquipmentItem> itemsForProject(String projectId) {
    return List.unmodifiable(
      _items.where((item) => item.projectId == projectId),
    );
  }

  Future<MaterialEquipmentItem> logUsage({
    required String projectId,
    required String itemName,
    required String type,
    required double quantity,
    required String unit,
    String notes = '',
  }) {
    if (projectId.trim().isEmpty || itemName.trim().isEmpty) {
      throw ArgumentError('Baustelle und Bezeichnung sind erforderlich.');
    }
    if (type != 'material' && type != 'geraet') {
      throw ArgumentError('Ungültige Kategorie.');
    }
    if (!quantity.isFinite || quantity <= 0) {
      throw ArgumentError('Die Menge muss größer als 0 sein.');
    }
    if (unit.trim().isEmpty) {
      throw ArgumentError('Eine Einheit ist erforderlich.');
    }

    final item = MaterialEquipmentItem(
      projectId: projectId,
      itemName: itemName.trim(),
      type: type,
      quantity: quantity,
      unit: unit.trim(),
      notes: notes.trim(),
    );
    _items.insert(0, item);
    return Future.value(item);
  }
}
