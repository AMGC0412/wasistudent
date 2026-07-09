import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Servicio para seleccionar y guardar fotos localmente.
///
/// Usa image_picker para acceder a la galería o cámara del dispositivo,
/// y path_provider para guardar copias en el almacenamiento de la app.
/// Las fotos se guardan con un nombre único (UUID) en el directorio
/// de documentos de la app.
class PhotoService {
  static const _uuid = Uuid();
  static final _picker = ImagePicker();

  /// Selecciona una foto de la galería.
  /// Retorna la ruta local del archivo guardado, o null si se canceló.
  static Future<String?> pickFromGallery() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    return _saveLocally(xfile);
  }

  /// Toma una foto con la cámara.
  static Future<String?> takePhoto() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    return _saveLocally(xfile);
  }

  /// Guarda el archivo seleccionado en el directorio de la app.
  static Future<String> _saveLocally(XFile xfile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDir.path, 'photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    final ext = p.extension(xfile.path);
    final filename = '${_uuid.v4()}$ext';
    final savedPath = p.join(photosDir.path, filename);
    await xfile.saveTo(savedPath);
    return savedPath;
  }

  /// Muestra un bottom sheet para elegir entre galería y cámara.
  static Future<String?> showPicker(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Seleccionar foto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Desde la galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await pickFromGallery();
                if (context.mounted) {
                  Navigator.of(context).pop(path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await takePhoto();
                if (context.mounted) {
                  Navigator.of(context).pop(path);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

