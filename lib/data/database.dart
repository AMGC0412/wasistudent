import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Inicialización de Hive para persistencia local.
class Database {
  Database._();

  static bool _initialized = false;

  static late Box authBox;
  static late Box roomsBox;
  static late Box contractsBox;
  static late Box reviewsBox;
  static late Box preferencesBox;
  static late Box favoritesBox;
  static late Box chatsBox;

  static Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    authBox = await Hive.openBox('auth');
    roomsBox = await Hive.openBox('rooms');
    contractsBox = await Hive.openBox('contracts');
    reviewsBox = await Hive.openBox('reviews');
    preferencesBox = await Hive.openBox('preferences');
    favoritesBox = await Hive.openBox('favorites');
    chatsBox = await Hive.openBox('chats');

    _initialized = true;
  }

  static Future<void> clearAll() async {
    await authBox.clear();
    await roomsBox.clear();
    await contractsBox.clear();
    await reviewsBox.clear();
    await preferencesBox.clear();
    await favoritesBox.clear();
    await chatsBox.clear();
  }
}
