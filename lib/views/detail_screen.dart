import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../theme/app_theme.dart';
import 'widgets/feedback_panel.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail karakter')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Obx(() {
          final character = controller.character.value;
          if (character == null && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (character == null && controller.errorMessage.value.isNotEmpty) {
            return FeedbackPanel(
              icon: Icons.cloud_off_outlined,
              title: 'Detail tidak dapat dimuat',
              message: controller.errorMessage.value,
              onRetry: controller.loadCharacter,
            );
          }
          if (character == null) {
            return const SizedBox.shrink();
          }

          final favoriteController = controller.favoriteController;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: AspectRatio(
                  aspectRatio: 1.05,
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white,
                      child: const Icon(Icons.person, size: 84),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      character.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.ink,
                          ),
                    ),
                  ),
                  Obx(
                    () => IconButton.filledTonal(
                      tooltip: favoriteController.isFavorite(character.id)
                          ? 'Hapus dari favorit'
                          : 'Tambah ke favorit',
                      onPressed: () => favoriteController.toggle(character),
                      icon: Icon(
                        favoriteController.isFavorite(character.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteController.isFavorite(character.id)
                            ? AppTheme.favorite
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(),
                ),
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Pembaruan data gagal: ${controller.errorMessage.value}',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              _InfoRow(
                label: 'Status',
                value: character.status,
                icon: Icons.circle,
              ),
              _InfoRow(
                label: 'Spesies',
                value: character.species,
                icon: Icons.biotech_outlined,
              ),
              _InfoRow(
                label: 'Gender',
                value: character.gender,
                icon: Icons.person_outline,
              ),
              _InfoRow(
                label: 'Origin',
                value: character.originName,
                icon: Icons.public,
              ),
              _InfoRow(
                label: 'Lokasi terakhir',
                value: character.locationName,
                icon: Icons.place_outlined,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
