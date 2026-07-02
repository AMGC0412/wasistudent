import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/room.dart';
import '../providers/room_provider.dart';
import '../theme/design.dart';
import '../utils/format_helpers.dart';

/// Pantalla de mapa REAL con flutter_map + OpenStreetMap.
///
/// 100% gratis: no requiere API key ni configuración.
/// Usa tiles de OpenStreetMap (licencia libre).
/// Los marcadores se posicionan en las coordenadas reales de cada cuarto.
///
/// Características:
/// - Mapa interactivo con zoom y pan
/// - Marcadores personalizados con el precio del cuarto
/// - Tap en marcador → card inferior con info
/// - Tap en card → detalle del cuarto
/// - Modo oscuro automático
class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  Room? _selectedRoom;
  final MapController _mapController = MapController();

  // Centro de Cusco (Plaza de Armas)
  static const LatLng _cuscoCenter = LatLng(-13.5170, -71.9780);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Cusco'),
        actions: [
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.view_list_rounded, size: 18),
            label: const Text('Lista'),
          ),
        ],
      ),
      body: Consumer<RoomProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 56, color: WasiDesign.textTertiary),
                  const SizedBox(height: WasiDesign.spaceMd),
                  const Text('No hay cuartos para mostrar en el mapa'),
                  const SizedBox(height: WasiDesign.spaceLg),
                  ElevatedButton(
                    onPressed: () => provider.loadRooms(),
                    child: const Text('Recargar'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // ── Mapa real con flutter_map ──
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _cuscoCenter,
                  initialZoom: 13.0,
                  minZoom: 11.0,
                  maxZoom: 18.0,
                  onTap: (_, __) {
                    setState(() => _selectedRoom = null);
                  },
                ),
                children: [
                  // Tiles de OpenStreetMap (gratis)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'app.wasistudent',
                    retinaMode: true,
                  ),
                  // Marcadores de cuartos
                  MarkerLayer(
                    markers: provider.allRooms.map((room) {
                      final isSelected = _selectedRoom?.id == room.id;
                      return Marker(
                        point: LatLng(room.lat, room.lng),
                        width: 80,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedRoom = room);
                            _mapController.move(
                              LatLng(room.lat, room.lng),
                              15.0,
                            );
                          },
                          child: _PriceMarker(
                            price: room.price,
                            isVerified: room.verificationLevel >= 2,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ── Contador de resultados ──
              Positioned(
                top: WasiDesign.spaceLg,
                left: WasiDesign.spaceLg,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WasiDesign.spaceMd,
                    vertical: WasiDesign.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: WasiDesign.surface,
                    borderRadius: BorderRadius.circular(WasiDesign.radiusXxl),
                    boxShadow: WasiDesign.shadowSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_work_outlined, size: 16, color: WasiDesign.primary),
                      const SizedBox(width: 6),
                      Text(
                        '${provider.allRooms.length} cuartos',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: WasiDesign.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Leyenda ──
              Positioned(
                top: WasiDesign.spaceLg,
                right: WasiDesign.spaceLg,
                child: Container(
                  padding: const EdgeInsets.all(WasiDesign.spaceSm),
                  decoration: BoxDecoration(
                    color: WasiDesign.surface,
                    borderRadius: BorderRadius.circular(WasiDesign.radiusMd),
                    boxShadow: WasiDesign.shadowSm,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LegendDot(color: WasiDesign.primary, label: 'Verificado'),
                      const SizedBox(height: 4),
                      _LegendDot(color: WasiDesign.accent, label: 'Básico'),
                    ],
                  ),
                ),
              ),

              // ── Card inferior del cuarto seleccionado ──
              if (_selectedRoom != null)
                Positioned(
                  left: WasiDesign.spaceLg,
                  right: WasiDesign.spaceLg,
                  bottom: WasiDesign.spaceXl,
                  child: _SelectedRoomCard(
                    room: _selectedRoom!,
                    onClose: () => setState(() => _selectedRoom = null),
                    onTap: () => context.push('/room/${_selectedRoom!.id}'),
                  ),
                ),

              // ── Atribución OSM (requerido por licencia) ──
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.white.withValues(alpha: 0.8),
                  child: const Text(
                    '© OpenStreetMap',
                    style: TextStyle(fontSize: 9, color: Colors.black87),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Marcador personalizado que muestra el precio del cuarto.
class _PriceMarker extends StatelessWidget {
  final double price;
  final bool isVerified;
  final bool isSelected;

  const _PriceMarker({
    required this.price,
    required this.isVerified,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVerified ? WasiDesign.primary : WasiDesign.accent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: isSelected
          ? (Matrix4.identity()..scale(1.2))
          : Matrix4.identity(),
      transformAlignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(WasiDesign.radiusSm),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'S/${price.round()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Triángulo inferior
          CustomPaint(
            size: const Size(10, 5),
            painter: _TrianglePainter(color: color),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _SelectedRoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onClose;
  final VoidCallback onTap;

  const _SelectedRoomCard({
    required this.room,
    required this.onClose,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(WasiDesign.spaceLg),
        decoration: BoxDecoration(
          color: WasiDesign.surface,
          borderRadius: BorderRadius.circular(WasiDesign.radiusXl),
          boxShadow: WasiDesign.shadowLg,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: WasiDesign.surfaceVariant,
                borderRadius: BorderRadius.circular(WasiDesign.radiusMd),
              ),
              child: const Icon(Icons.home_work_outlined, color: WasiDesign.primary),
            ),
            const SizedBox(width: WasiDesign.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: WasiDesign.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: WasiDesign.textTertiary),
                      const SizedBox(width: 2),
                      Text(room.district, style: const TextStyle(fontSize: 12, color: WasiDesign.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    F.pricePerMonth(room.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: WasiDesign.primary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, size: 20),
              color: WasiDesign.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
