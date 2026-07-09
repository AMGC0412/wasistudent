import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/room.dart';
import 'database.dart';

/// Repositorio de habitaciones con persistencia en Hive.
///
/// Los cuartos se guardan como JSON en la caja `roomsBox`.
/// Cada cuarto tiene un ID único generado con UUID.
class RoomRepository {
  static const _uuid = Uuid();

  static List<Room> getAll() {
    final box = Database.roomsBox;
    return box.values.map((v) {
      final map = Map<String, dynamic>.from(jsonDecode(v as String));
      return Room.fromJson(map);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static List<Room> getByOwner(String ownerId) {
    return getAll().where((r) => r.ownerId == ownerId).toList();
  }

  static Room? getById(String id) {
    final raw = Database.roomsBox.get(id);
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(jsonDecode(raw as String));
    return Room.fromJson(map);
  }

  static Future<Room> create(Room room) async {
    final newRoom = room.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    await Database.roomsBox.put(newRoom.id, jsonEncode(newRoom.toJson()));
    return newRoom;
  }

  static Future<void> update(Room room) async {
    await Database.roomsBox.put(room.id, jsonEncode(room.toJson()));
  }

  static Future<void> delete(String id) async {
    await Database.roomsBox.delete(id);
  }

  /// Busca cuartos por texto (título, distrito, descripción).
  static List<Room> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final q = query.toLowerCase();
    return getAll().where((r) {
      return r.title.toLowerCase().contains(q) ||
          r.district.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q) ||
          r.ownerName.toLowerCase().contains(q);
    }).toList();
  }

  /// Filtra cuartos por criterios básicos.
  static List<Room> filter({
    String? district,
    double? maxPrice,
    int? minVerificationLevel,
    bool? onlyAvailable,
  }) {
    return getAll().where((r) {
      if (district != null && district.isNotEmpty && r.district != district) {
        return false;
      }
      if (maxPrice != null && r.price > maxPrice) {
        return false;
      }
      if (minVerificationLevel != null &&
          r.verificationLevel < minVerificationLevel) {
        return false;
      }
      if (onlyAvailable == true && !r.isActive) {
        return false;
      }
      return true;
    }).toList();
  }
}
