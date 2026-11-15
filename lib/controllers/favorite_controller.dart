import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/character.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';

class FavoriteController extends GetxController {
  FavoriteController(this._storage);

  final LocalStorageService _storage;
  final RxList<Character> favorites = <Character>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  Future<void> _writeQueue = Future<void>.value();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  bool isFavorite(int characterId) =>
      favorites.any((character) => character.id == characterId);

  Future<void> loadFavorites() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      favorites.assignAll(_storage.getFavorites());
    } on Object catch (error) {
      errorMessage.value = 'Favorit tidak dapat dimuat: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(Character character) async {
    if (isFavorite(character.id)) {
      await remove(character.id);
      return;
    }

    favorites.insert(0, character);
    if (!await _persist()) {
      favorites.removeWhere((item) => item.id == character.id);
      return;
    }
    Get.snackbar(
      'Favorit ditambahkan',
      '${character.name} tersimpan di daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primary,
      colorText: Colors.white,
    );
  }

  Future<void> remove(int characterId) async {
    final index = favorites.indexWhere((item) => item.id == characterId);
    if (index < 0) return;

    final removed = favorites.removeAt(index);
    if (!await _persist()) {
      if (!isFavorite(characterId)) {
        favorites.insert(
          index < favorites.length ? index : favorites.length,
          removed,
        );
      }
      return;
    }
    Get.snackbar(
      'Favorit dihapus',
      '${removed.name} dihapus dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primary,
      colorText: Colors.white,
    );
  }

  Future<bool> _persist() async {
    final snapshot = favorites.toList();
    var succeeded = true;
    _writeQueue = _writeQueue
        .then((_) => _storage.saveFavorites(snapshot))
        .catchError((Object error) {
          succeeded = false;
          Get.snackbar(
            'Gagal menyimpan favorit',
            error.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        });
    await _writeQueue;
    return succeeded;
  }
}
