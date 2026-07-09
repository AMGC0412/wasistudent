import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/room_repository.dart';
import '../models/room.dart';
import '../models/user_preferences.dart' show RoomType, GenderPreference, ContractType;
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import '../services/photo_service.dart';
import '../theme/design.dart';

/// Pantalla para que una propietaria publique un cuarto nuevo.
///
/// Permite:
/// - Subir fotos reales desde la galería o cámara (image_picker)
/// - Llenar todos los campos del cuarto
/// - Seleccionar ubicación en mapa (coordenadas)
/// - Guardar con persistencia local (Hive)
class PublishRoomScreen extends StatefulWidget {
  const PublishRoomScreen({super.key});

  @override
  State<PublishRoomScreen> createState() => _PublishRoomScreenState();
}

class _PublishRoomScreenState extends State<PublishRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _walkingTimeController = TextEditingController();

  String _district = 'San Jerónimo';
  String _roomType = 'private';
  ContractType _contractType = ContractType.semester;
  GenderPreference _genderPref = GenderPreference.any;

  bool _acceptsCouples = false;
  bool _acceptsPets = false;
  bool _acceptsForeigners = true;
  bool _isFurnished = true;

  // Coordenadas default (San Jerónimo, Cusco)
  double _lat = -13.5319;
  double _lng = -71.9675;

  List<String> _selectedAmenities = [];
  List<String> _photos = [];

  final _allAmenities = [
    'Wi-Fi', 'Agua caliente', 'Cocina compartida', 'Cocina propia',
    'Baño privado', 'Lavandería', 'Calefacción', 'Escritorio',
    'Closet', 'TV', 'Jardín', 'Patio', 'Estacionamiento',
    'Seguridad 24/7', 'Balcón',
  ];

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _walkingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar cuarto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(WasiDesign.spaceLg),
          children: [
            // ── Sección de fotos ──
            _buildSectionTitle('Fotos del cuarto'),
            const SizedBox(height: WasiDesign.spaceSm),
            _buildPhotosSection(),
            const SizedBox(height: WasiDesign.spaceXl),

            // ── Información básica ──
            _buildSectionTitle('Información básica'),
            const SizedBox(height: WasiDesign.spaceMd),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título del anuncio',
                hintText: 'Ej: Cuarto individual luminoso cerca a la UNSAAC',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingresa un título' : null,
            ),
            const SizedBox(height: WasiDesign.spaceMd),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Describe el cuarto, la zona, las reglas...',
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingresa una descripción' : null,
            ),
            const SizedBox(height: WasiDesign.spaceXl),

            // ── Precio y ubicación ──
            _buildSectionTitle('Precio y ubicación'),
            const SizedBox(height: WasiDesign.spaceMd),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio (S/)',
                      hintText: '280',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Ingresa el precio'
                        : null,
                  ),
                ),
                const SizedBox(width: WasiDesign.spaceMd),
                Expanded(
                  child: TextFormField(
                    controller: _sizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tamaño (m²)',
                      hintText: '12',
                      prefixIcon: Icon(Icons.square_foot_outlined),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: WasiDesign.spaceMd),
            DropdownButtonFormField<String>(
              initialValue: _district,
              decoration: const InputDecoration(
                labelText: 'Distrito',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'San Jerónimo', child: Text('San Jerónimo')),
                DropdownMenuItem(value: 'San Sebastián', child: Text('San Sebastián')),
                DropdownMenuItem(value: 'Santiago', child: Text('Santiago')),
                DropdownMenuItem(value: 'Wanchaq', child: Text('Wanchaq')),
                DropdownMenuItem(value: 'Cusco Centro', child: Text('Cusco Centro')),
                DropdownMenuItem(value: 'San Blas', child: Text('San Blas')),
                DropdownMenuItem(value: 'Poroy', child: Text('Poroy')),
                DropdownMenuItem(value: 'San Cristóbal', child: Text('San Cristóbal')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _district = v);
              },
            ),
            const SizedBox(height: WasiDesign.spaceMd),
            TextFormField(
              controller: _walkingTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutos caminando a la universidad',
                hintText: '8',
                prefixIcon: Icon(Icons.directions_walk_outlined),
              ),
            ),
            const SizedBox(height: WasiDesign.spaceXl),

            // ── Tipo y características ──
            _buildSectionTitle('Tipo y características'),
            const SizedBox(height: WasiDesign.spaceSm),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'private', label: Text('Privado'), icon: Icon(Icons.person_outline)),
                ButtonSegment(value: 'shared', label: Text('Compartido'), icon: Icon(Icons.people_outline)),
                ButtonSegment(value: 'studio', label: Text('Estudio'), icon: Icon(Icons.home_outlined)),
              ],
              selected: {_roomType},
              onSelectionChanged: (s) => setState(() => _roomType = s.first),
            ),
            const SizedBox(height: WasiDesign.spaceMd),
            Wrap(
              spacing: WasiDesign.spaceSm,
              runSpacing: WasiDesign.spaceSm,
              children: _allAmenities.map((a) {
                final selected = _selectedAmenities.contains(a);
                return FilterChip(
                  label: Text(a),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedAmenities.add(a);
                      } else {
                        _selectedAmenities.remove(a);
                      }
                    });
                  },
                  selectedColor: WasiDesign.primary.withValues(alpha: 0.15),
                  checkmarkColor: WasiDesign.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: WasiDesign.spaceXl),

            // ── Permisos ──
            _buildSectionTitle('Permisos'),
            const SizedBox(height: WasiDesign.spaceSm),
            SwitchListTile(
              title: const Text('Amueblado'),
              value: _isFurnished,
              onChanged: (v) => setState(() => _isFurnished = v),
            ),
            SwitchListTile(
              title: const Text('Acepta parejas'),
              value: _acceptsCouples,
              onChanged: (v) => setState(() => _acceptsCouples = v),
            ),
            SwitchListTile(
              title: const Text('Acepta mascotas'),
              value: _acceptsPets,
              onChanged: (v) => setState(() => _acceptsPets = v),
            ),
            SwitchListTile(
              title: const Text('Acepta extranjeros'),
              value: _acceptsForeigners,
              onChanged: (v) => setState(() => _acceptsForeigners = v),
            ),
            const SizedBox(height: WasiDesign.spaceXxl),

            // ── Botón publicar ──
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _publish,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.publish_outlined),
              label: Text(
                _isSaving ? 'Publicando...' : 'Publicar cuarto',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: WasiDesign.spaceLg),
              ),
            ),
            const SizedBox(height: WasiDesign.spaceXl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: WasiDesign.textPrimary,
      ),
    );
  }

  Widget _buildPhotosSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Botón agregar foto
          GestureDetector(
            onTap: _addPhoto,
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: WasiDesign.spaceMd),
              decoration: BoxDecoration(
                color: WasiDesign.surfaceVariant,
                borderRadius: BorderRadius.circular(WasiDesign.radiusMd),
                border: Border.all(
                  color: WasiDesign.outline,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: WasiDesign.primary, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    'Agregar\nfoto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: WasiDesign.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fotos seleccionadas
          ..._photos.map((path) => _buildPhotoTile(path)),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(String path) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          margin: const EdgeInsets.only(right: WasiDesign.spaceMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WasiDesign.radiusMd),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: WasiDesign.spaceMd + 4,
          child: GestureDetector(
            onTap: () => setState(() => _photos.remove(path)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addPhoto() async {
    final path = await PhotoService.showPicker(context);
    if (path != null) {
      setState(() => _photos.add(path));
    }
  }

  Future<void> _publish() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos una foto del cuarto'),
          backgroundColor: WasiDesign.warning,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = context.read<AuthProvider>().currentUser!;
      final room = Room(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        district: _district,
        lat: _lat,
        lng: _lng,
        amenities: _selectedAmenities,
        imageUrls: _photos,
        verificationLevel: 1,
        trustScore: user.trustScore,
        ownerName: user.name,
        ownerAvatar: user.avatar,
        ownerRating: 0.0,
        ownerId: user.id,
        ownerPhone: user.phone,
        ownerMemberSince: user.memberSince,
        isFurnished: _isFurnished,
        acceptsCouples: _acceptsCouples,
        acceptsPets: _acceptsPets,
        acceptsForeigners: _acceptsForeigners,
        genderPreference: _genderPref,
        maxOccupants: 1,
        sizeSqm: double.tryParse(_sizeController.text) ?? 0,
        roomType: RoomType.values.firstWhere(
          (e) => e.name == _roomType,
          orElse: () => RoomType.private,
        ),
        walkingTimeMin: int.tryParse(_walkingTimeController.text) ?? 0,
        distanceKm: 0.5,
        matchingScore: 0,
        lifestyleTags: const [],
        contractType: _contractType,
        hasDigitalContract: true,
        availableFrom: DateTime.now().add(const Duration(days: 7)),
        minContractMonths: 6,
        depositAmount: double.tryParse(_priceController.text) ?? 0,
        createdAt: DateTime.now(),
        houseRules: const [],
        nearbyPlaces: const [],
      );

      await context.read<RoomProvider>().addRoom(room);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuarto publicado! Un verificador lo visitará pronto.'),
          backgroundColor: WasiDesign.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: WasiDesign.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
