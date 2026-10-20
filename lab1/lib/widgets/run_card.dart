import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';

class RunCard extends StatelessWidget {
  const RunCard({
    super.key,
    required this.item,
    required this.onFavouriteChanged,
    required this.onTap,
  });

  final Item item;
  final ValueChanged<Item> onFavouriteChanged;
  final VoidCallback onTap;

  String? get _availabilityBadge {
    if (item.isFull) {
      return 'FULL';
    }
    if (item.freePlaces > 0 && item.freePlaces <= 5) {
      return '${item.freePlaces} left';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final badge = _availabilityBadge;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: item.category.color(colors),
                    child: Icon(item.category.icon, color: colors.surface),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -10,
                      right: -14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.isFull ? colors.error : colors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: item.isFull
                                    ? colors.onError
                                    : colors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    _RunDetail(
                      icon: Icons.calendar_today_outlined,
                      text: formatDateTime(item.dateTime),
                    ),
                    const SizedBox(height: 6),
                    _RunDetail(
                      icon: item.isOnline
                          ? Icons.videocam_outlined
                          : Icons.place_outlined,
                      text: item.location,
                    ),
                    const SizedBox(height: 6),
                    _RunDetail(
                      icon: Icons.people_outline,
                      text:
                          '${item.places.taken}/${item.participantLimit} joined',
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: item.isFavourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                onPressed: () => onFavouriteChanged(item),
                icon: Icon(
                  item.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: item.isFavourite
                    ? colors.error
                    : colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunDetail extends StatelessWidget {
  const _RunDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
