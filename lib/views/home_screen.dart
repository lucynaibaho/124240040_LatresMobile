import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/character_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/character.dart';
import '../routes/app_pages.dart';
import 'widgets/character_tile.dart';
import 'widgets/feedback_panel.dart';

class HomeScreen extends GetView<CharacterController> {
  const HomeScreen({super.key});

  static const _filters = <String, String?>{
    'Semua': null,
    'Alive': 'alive',
    'Dead': 'dead',
    'Unknown': 'unknown',
  };

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            onChanged: controller.search,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Cari nama karakter...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 54,
          child: Obx(
            () => ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: _filters.entries.map((entry) {
                final selected = controller.selectedStatus.value == entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(entry.key),
                    selected: selected,
                    onSelected: (_) => controller.setStatus(entry.value),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.characters.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.value.isNotEmpty) {
              return FeedbackPanel(
                icon: Icons.cloud_off_outlined,
                title: 'Karakter tidak dapat dimuat',
                message: controller.errorMessage.value,
                onRetry: controller.loadCharacters,
              );
            }
            if (controller.characters.isEmpty) {
              return FeedbackPanel(
                icon: Icons.search_off,
                title: 'Karakter tidak ditemukan',
                message: 'Coba ubah kata kunci atau filter status.',
                onRetry: controller.loadCharacters,
              );
            }
            return RefreshIndicator(
              onRefresh: controller.loadCharacters,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: controller.characters.length,
                itemBuilder: (context, index) {
                  final Character character = controller.characters[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Obx(
                      () => CharacterTile(
                        character: character,
                        isFavorite: favoriteController.isFavorite(character.id),
                        onTap: () =>
                            Get.toNamed(AppRoutes.detail, arguments: character),
                        onFavoriteTap: () =>
                            favoriteController.toggle(character),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
