import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/character.dart';
import '../routes/app_pages.dart';
import 'widgets/character_tile.dart';
import 'widgets/feedback_panel.dart';

class FavoritesScreen extends GetView<FavoriteController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value.isNotEmpty) {
        return FeedbackPanel(
          icon: Icons.error_outline,
          title: 'Favorit tidak dapat dimuat',
          message: controller.errorMessage.value,
          onRetry: controller.loadFavorites,
        );
      }
      if (controller.favorites.isEmpty) {
        return const FeedbackPanel(
          icon: Icons.favorite_border,
          title: 'Belum ada favorit',
          message: 'Tekan ikon hati pada karakter untuk menyimpannya di sini.',
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final Character character = controller.favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey(character.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              onDismissed: (_) => controller.remove(character.id),
              child: CharacterTile(
                character: character,
                isFavorite: true,
                onTap: () =>
                    Get.toNamed(AppRoutes.detail, arguments: character),
                onFavoriteTap: () => controller.remove(character.id),
              ),
            ),
          );
        },
      );
    });
  }
}
