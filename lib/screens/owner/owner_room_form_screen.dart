import 'package:flutter/material.dart';

import '../../config/theme.dart';

/// Formulario para publicar un cuarto nuevo.
///
/// Cascarón mockup: solo muestra el formulario con campos principales.
/// Al guardar, muestra SnackBar de éxito y regresa.
///
/// En producción, este formulario tendría:
/// - Subida de fotos.
/// - Selector de ubicación en mapa.
/// - Checklist de los 12 puntos verificables (auto-evaluación).
/// - Vista previa antes de publicar.
class OwnerRoomFormScreen extends StatefulWidget {
  const OwnerRoomFormScreen({super.key});

  @override
  State<OwnerRoomFormScreen> createState() => _OwnerRoomFormScreenState();
}

class _OwnerRoomFormScreenState extends State<OwnerRoomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _districtController = TextEditingController(text: 'San Jerónimo');
  final _sizeController = TextEditingController();
  String _roomType = 'private';
  bool _acceptsCouples = false;
  bool _acceptsPets = false;
  bool _acceptsForeigners = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _districtController.dispose();
    _sizeController.dispose();
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
          padding: const EdgeInsets.all(16),
          children: [
            // Banner info
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: WasiColors.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: WasiColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tu primer cuarto es gratis. Un verificador de '
                      'WasiStudent lo visitará en los próximos 7 días '
                      'para verificarlo en persona.',
                      style: TextStyle(
                        fontSize: 12,
                        color: WasiColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Título
            _Label(text: 'Título del anuncio'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Ej: Cuarto individual luminoso cerca a la UNSAAC',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingresa un título' : null,
            ),
            const SizedBox(height: 16),

            // Descripción
            _Label(text: 'Descripción'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe tu cuarto: tamaño, servicios, zona, reglas...',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingresa una descripción' : null,
            ),
            const SizedBox(height: 16),

            // Precio y distrito
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(text: 'Precio mensual (S/)'),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '280',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Ingresa precio' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(text: 'Distrito'),
                      DropdownButtonFormField<String>(
                        initialValue: _districtController.text,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'San Jerónimo', child: Text('San Jerónimo')),
                          DropdownMenuItem(
                              value: 'San Sebastián', child: Text('San Sebastián')),
                          DropdownMenuItem(value: 'Santiago', child: Text('Santiago')),
                          DropdownMenuItem(value: 'Wanchaq', child: Text('Wanchaq')),
                          DropdownMenuItem(
                              value: 'Cusco Centro', child: Text('Cusco Centro')),
                          DropdownMenuItem(value: 'San Blas', child: Text('San Blas')),
                          DropdownMenuItem(value: 'Poroy', child: Text('Poroy')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            _districtController.text = v;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tamaño
            _Label(text: 'Tamaño (m²)'),
            TextFormField(
              controller: _sizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '12',
                prefixIcon: Icon(Icons.square_foot_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de cuarto
            _Label(text: 'Tipo de cuarto'),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'private',
                  label: Text('Privado'),
                  icon: Icon(Icons.person_outline),
                ),
                ButtonSegment(
                  value: 'shared',
                  label: Text('Compartido'),
                  icon: Icon(Icons.people_outline),
                ),
                ButtonSegment(
                  value: 'studio',
                  label: Text('Estudio'),
                  icon: Icon(Icons.home_outlined),
                ),
              ],
              selected: {_roomType},
              onSelectionChanged: (set) {
                setState(() => _roomType = set.first);
              },
            ),
            const SizedBox(height: 16),

            // Permisos
            _Label(text: 'Permisos'),
            const SizedBox(height: 6),
            _SwitchTile(
              label: 'Acepta parejas',
              value: _acceptsCouples,
              onChanged: (v) => setState(() => _acceptsCouples = v),
            ),
            _SwitchTile(
              label: 'Acepta mascotas',
              value: _acceptsPets,
              onChanged: (v) => setState(() => _acceptsPets = v),
            ),
            _SwitchTile(
              label: 'Acepta extranjeros',
              value: _acceptsForeigners,
              onChanged: (v) => setState(() => _acceptsForeigners = v),
            ),
            const SizedBox(height: 24),

            // Botón publicar
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.publish_outlined),
              label: const Text(
                'Publicar cuarto',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: WasiColors.primary,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Cuarto publicado. Un verificador te contactará en 48 horas '
          'para coordinar la visita de verificación.',
        ),
        backgroundColor: WasiColors.success,
      ),
    );
    Navigator.of(context).pop();
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: WasiColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(fontSize: 13),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      dense: true,
    );
  }
}
