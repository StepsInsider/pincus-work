class PhotoDocumentation {
  const PhotoDocumentation({
    required this.projectId,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.category,
    required this.createdAt,
  });

  final String projectId;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String note;
  final String category;
  final DateTime createdAt;
}
