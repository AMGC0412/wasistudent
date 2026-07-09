import '../data/database.dart';

/// Repositorio de favoritos con persistencia en Hive.
class FavoritesRepository {
  static List<String> getFavoriteIds() {
    final list = Database.favoritesBox.get('ids');
    if (list == null) return [];
    return List<String>.from(list as List);
  }

  static bool isFavorite(String roomId) {
    return getFavoriteIds().contains(roomId);
  }

  static void toggle(String roomId) {
    final ids = getFavoriteIds();
    if (ids.contains(roomId)) {
      ids.remove(roomId);
    } else {
      ids.add(roomId);
    }
    Database.favoritesBox.put('ids', ids);
  }

  static void add(String roomId) {
    final ids = getFavoriteIds();
    if (!ids.contains(roomId)) {
      ids.add(roomId);
      Database.favoritesBox.put('ids', ids);
    }
  }

  static void remove(String roomId) {
    final ids = getFavoriteIds();
    ids.remove(roomId);
    Database.favoritesBox.put('ids', ids);
  }

  static int get count => getFavoriteIds().length;
}
