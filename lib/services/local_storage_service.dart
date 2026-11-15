import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../models/character.dart';

class LocalStorageService {
  LocalStorageService(this._preferences);

  static const _sessionKey = 'session.v1';
  static const _favoritesKey = 'favorites.v1';

  final SharedPreferences _preferences;

  AppUser? getSession() {
    final encoded = _preferences.getString(_sessionKey);
    if (encoded == null) return null;
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Data sesi lokal tidak valid.');
    }
    return AppUser.fromJson(decoded);
  }

  Future<void> saveSession(AppUser user) async {
    await _write(_sessionKey, jsonEncode(user.toJson()));
  }

  Future<void> clearSession() async {
    final removed = await _preferences.remove(_sessionKey);
    if (!removed && _preferences.containsKey(_sessionKey)) {
      throw StateError('Sesi tidak dapat dihapus dari penyimpanan lokal.');
    }
  }

  List<Character> getFavorites() {
    final encoded = _preferences.getString(_favoritesKey);
    if (encoded == null) return [];
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Penyimpanan favorit lokal tidak valid.');
    }
    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Data favorit lokal tidak valid.');
      }
      return Character.fromJson(item);
    }).toList();
  }

  Future<void> saveFavorites(List<Character> characters) async {
    await _write(
      _favoritesKey,
      jsonEncode(characters.map((character) => character.toJson()).toList()),
    );
  }

  Future<void> _write(String key, String value) async {
    final saved = await _preferences.setString(key, value);
    if (!saved) {
      throw StateError('Data tidak dapat disimpan ke penyimpanan lokal.');
    }
  }
}
