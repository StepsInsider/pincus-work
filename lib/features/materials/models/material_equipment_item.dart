class MaterialEquipmentItem {
  MaterialEquipmentItem({
    required this.projectId,
    required this.itemName,
    required this.type,
    required this.quantity,
    required this.unit,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String projectId;
  final String itemName;
  final String type;
  final double quantity;
  final String unit;
  final String notes;
  final DateTime createdAt;

  bool get isEquipment => type == 'geraet';
}
