import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/photos/models/photo_documentation.dart';

class PhotoDocumentationService {
  PhotoDocumentationService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<PhotoDocumentation?> captureAndUploadDocumentation({
    required String projectId,
    required String note,
    required String category,
  }) async {
    if (projectId.trim().isEmpty) {
      throw ArgumentError('Eine Baustelle ist erforderlich.');
    }
    if (!const {'vorher', 'nachher', 'fortschritt'}.contains(category)) {
      throw ArgumentError('Ungültige Fotokategorie.');
    }

    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image == null) return null;

    final position = await _determinePosition();
    final fileName =
        'projects/$projectId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageBytes = await image.readAsBytes();

    await _supabase.storage
        .from('site-photos')
        .uploadBinary(
          fileName,
          imageBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    final imageUrl = _supabase.storage
        .from('site-photos')
        .getPublicUrl(fileName);
    final createdAt = DateTime.now().toUtc();

    await _supabase.from('site_documentations').insert({
      'project_id': projectId,
      'image_url': imageUrl,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'note': note.trim(),
      'category': category,
      'created_at': createdAt.toIso8601String(),
    });

    return PhotoDocumentation(
      projectId: projectId,
      imageUrl: imageUrl,
      latitude: position.latitude,
      longitude: position.longitude,
      note: note.trim(),
      category: category,
      createdAt: createdAt,
    );
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Standortdienste sind deaktiviert.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw StateError('Standortberechtigung wurde verweigert.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw StateError('Standortberechtigung ist dauerhaft verweigert.');
    }

    return Geolocator.getCurrentPosition();
  }
}
