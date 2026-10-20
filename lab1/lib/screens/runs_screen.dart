import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';

class RunsScreen extends StatelessWidget {
  const RunsScreen({
    super.key,
    required this.items,
    required this.onFavouriteChanged,
  });

  final List<Item> items;
  final ValueChanged<Item> onFavouriteChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No runs yet.'));
    }

    return ListView(
      children: [
        for (final item in items)
          ListTile(
            title: Text(item.title),
            subtitle: Text(
              '${item.category.label} · ${formatDateTime(item.dateTime)}',
            ),
            trailing: IconButton(
              tooltip: item.isFavourite
                  ? 'Remove from favourites'
                  : 'Add to favourites',
              icon: Icon(
                item.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () => onFavouriteChanged(item),
            ),
          ),
      ],
    );
  }
}
