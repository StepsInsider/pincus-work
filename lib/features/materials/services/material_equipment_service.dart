import '../models/material_equipment_item.dart';

class MaterialEquipmentService {
  final List<MaterialEquipmentItem> _items = [];

  List<MaterialEquipmentItem> itemsForProject(String projectId) {
    return _items.where((item) => item.projectId == projectId).toList();
  }

  void addItem(MaterialEquipmentItem item) {
    _items.add(item);
  }
}
