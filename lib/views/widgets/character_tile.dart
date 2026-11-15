import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../../theme/app_theme.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({
    required this.character,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    super.key,
  });

  final Character character;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (character.status.toLowerCase()) {
      'alive' => const Color(0xFF2E9D68),
      'dead' => const Color(0xFFD75454),
      _ => Colors.blueGrey,
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  character.image,
                  width: 82,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 82,
                    height: 92,
                    color: AppTheme.canvas,
                    child: const Icon(Icons.person, size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 9, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          character.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      character.species,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavoriteTap,
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah favorit',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.favorite : AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
