import 'package:flutter/material.dart';

import '../data/favorites_repository.dart';
import '../data/room_repository.dart';
import '../models/room.dart';
import '../models/user_preferences.dart' show RoomType;

/// Proveedor de habitaciones que usa RoomRepository (Hive) para
/// persistencia real. Las propietarias pueden publicar cuartos y
/// estos se guardan localmente.
class RoomProvider extends ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  bool _isLoading = false;
  String? _error;

  // Filtros
  String _filterDistrict = '';
  String _sortBy = 'newest';
  double? _filterBudget;
  RoomType? _filterRoomType;
  bool _filterVerified = false;
  bool _filterAvailable = false;

  // Comparación
  final List<String> _compareList = [];

  // Búsqueda
  List<Room> _searchResults = [];
  bool _isSearching = false;

  // Vistos recientemente
  final List<String> _recentlyViewed = [];

  List<Room> get allRooms => _rooms;
  List<Room> get rooms => _filteredRooms.isEmpty ? _rooms : _filteredRooms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filterDistrict => _filterDistrict;
  String get sortBy => _sortBy;

  List<Room> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  List<Room> get recentlyViewed => _recentlyViewed
      .map((id) => getRoomById(id))
      .where((r) => r != null && r.id.isNotEmpty)
      .cast<Room>()
      .toList();

  /// Cuartos verificados (nivel >= 2).
  List<Room> get verifiedRooms =>
      _rooms.where((r) => r.verificationLevel >= 2).toList();

  /// Cuartos favoritos del usuario.
  List<Room> get favorites => favoriteRooms;

  // ── Comparación ──

  List<String> get compareList => List.unmodifiable(_compareList);
  bool get canCompare => _compareList.length == 2;

  bool isInCompare(String roomId) => _compareList.contains(roomId);

  void toggleCompare(String roomId) {
    if (_compareList.contains(roomId)) {
      _compareList.remove(roomId);
    } else if (_compareList.length < 2) {
      _compareList.add(roomId);
    } else {
      // Reemplazar el primero
      _compareList.removeAt(0);
      _compareList.add(roomId);
    }
    notifyListeners();
  }

  List<Room> getComparedRooms() {
    return _compareList
        .map((id) => getRoomById(id))
        .where((r) => r != null && r.id.isNotEmpty)
        .cast<Room>()
        .toList();
  }

  void clearCompare() {
    _compareList.clear();
    notifyListeners();
  }

  // ── Filtros ──

  int get activeFilterCount {
    int count = 0;
    if (_filterDistrict.isNotEmpty) count++;
    if (_filterBudget != null) count++;
    if (_filterRoomType != null) count++;
    if (_filterVerified) count++;
    if (_filterAvailable) count++;
    return count;
  }

  void setFilterDistrict(String district) {
    _filterDistrict = district;
    _applyFilters();
  }

  void setFilterBudget(double? budget) {
    _filterBudget = budget;
    _applyFilters();
  }

  void setFilterRoomType(RoomType? type) {
    _filterRoomType = type;
    _applyFilters();
  }

  void setFilterVerified(bool verified) {
    _filterVerified = verified;
    _applyFilters();
  }

  void setFilterAvailable(bool available) {
    _filterAvailable = available;
    _applyFilters();
  }

  /// Método alias para compatibilidad con pantallas existentes.
  void filterRooms(dynamic prefs) {
    _applyFilters();
  }

  void sortRooms(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  void _applyFilters() {
    var rooms = List<Room>.from(_rooms);

    if (_filterDistrict.isNotEmpty) {
      rooms = rooms.where((r) => r.district == _filterDistrict).toList();
    }
    if (_filterBudget != null) {
      rooms = rooms.where((r) => r.price <= _filterBudget!).toList();
    }
    if (_filterRoomType != null) {
      rooms = rooms.where((r) => r.roomType == _filterRoomType).toList();
    }
    if (_filterVerified) {
      rooms = rooms.where((r) => r.verificationLevel >= 2).toList();
    }
    if (_filterAvailable) {
      rooms = rooms.where((r) => r.isActive).toList();
    }

    switch (_sortBy) {
      case 'price_low':
        rooms.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        rooms.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'distance':
        rooms.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'rating':
        rooms.sort((a, b) => b.ownerRating.compareTo(a.ownerRating));
        break;
      case 'newest':
      default:
        rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    _filteredRooms = rooms;
    notifyListeners();
  }

  // ── Búsqueda ──

  Future<void> searchRooms(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _searchResults = RoomRepository.search(query);
    _isSearching = false;
    notifyListeners();
  }

  // ── Carga de datos ──

  RoomProvider() {
    loadRooms();
  }

  Future<void> loadRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      _rooms = RoomRepository.getAll();
      _applyFilters();
    } catch (e) {
      _error = 'Error al cargar habitaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Room? getRoomById(String id) {
    // Buscar en memoria primero
    for (final r in _rooms) {
      if (r.id == id) return r;
    }
    // Si no está, buscar en repositorio
    return RoomRepository.getById(id);
  }

  bool isFavorite(String roomId) =>
      FavoritesRepository.isFavorite(roomId);

  void toggleFavorite(String roomId) {
    FavoritesRepository.toggle(roomId);
    notifyListeners();
  }

  List<Room> get favoriteRooms =>
      FavoritesRepository.getFavoriteIds()
          .map((id) => getRoomById(id))
          .where((r) => r != null && r!.id.isNotEmpty)
          .cast<Room>()
          .toList();

  List<Room> getFeaturedRooms() {
    final featured = _rooms.where((r) => r.isFeatured).toList();
    return featured.isEmpty ? _rooms.take(5).toList() : featured;
  }

  /// Cuartos verificados recientemente (ordenados por createdAt).
  List<Room> getVerifiedRooms() {
    final verified = _rooms.where((r) => r.verificationLevel >= 2).toList();
    verified.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return verified.take(5).toList();
  }

  List<Room> getUrgentRooms() {
    return _rooms.where((r) => r.isUrgent).toList();
  }

  /// Cuartos "Para ti" — featured + verificados, hasta 5.
  List<Room> getRecommendedRooms() {
    final recommended = <Room>[];
    recommended.addAll(_rooms.where((r) => r.isFeatured));
    recommended.addAll(_rooms.where((r) => r.verificationLevel >= 2 && !r.isFeatured));
    return recommended.take(5).toList();
  }

  void addToRecentlyViewed(String roomId) {
    _recentlyViewed.remove(roomId);
    _recentlyViewed.insert(0, roomId);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed.removeLast();
    }
    notifyListeners();
  }

  void clearFilters() {
    _filterDistrict = '';
    _sortBy = 'newest';
    _filterBudget = null;
    _filterRoomType = null;
    _filterVerified = false;
    _filterAvailable = false;
    _applyFilters();
  }

  /// Agrega un cuarto nuevo (para propietarias).
  Future<void> addRoom(Room room) async {
    await RoomRepository.create(room);
    await loadRooms();
  }

  /// Actualiza un cuarto existente.
  Future<void> updateRoom(Room room) async {
    await RoomRepository.update(room);
    await loadRooms();
  }

  /// Elimina un cuarto.
  Future<void> deleteRoom(String id) async {
    await RoomRepository.delete(id);
    await loadRooms();
  }
}
