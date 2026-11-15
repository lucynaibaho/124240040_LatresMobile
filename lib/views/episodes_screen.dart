import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/episode_controller.dart';
import '../models/episode.dart';
import 'widgets/feedback_panel.dart';

class EpisodesScreen extends GetView<EpisodeController> {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.episodes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value.isNotEmpty) {
        return FeedbackPanel(
          icon: Icons.cloud_off_outlined,
          title: 'Episode tidak dapat dimuat',
          message: controller.errorMessage.value,
          onRetry: controller.loadEpisodes,
        );
      }
      return RefreshIndicator(
        onRefresh: controller.loadEpisodes,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: controller.episodes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final Episode episode = controller.episodes[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.12),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.play_arrow_rounded),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          episode.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${episode.episodeCode}  •  ${episode.airDate}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
