import 'package:flutter/material.dart';

import '../models/item.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({
    super.key,
    required this.items,
    required this.onFavouriteChanged,
  });

  final List<Item> items;
  final ValueChanged<Item> onFavouriteChanged;

  @override
  Widget build(BuildContext context) {
    final favourites = items.where((item) => item.isFavourite).toList();
    if (favourites.isEmpty) {
      return const Center(child: Text('No favourite runs yet.'));
    }

    return ListView(
      children: [
        for (final item in favourites)
          ListTile(
            title: Text(item.title),
            subtitle: Text(item.category.label),
            trailing: IconButton(
              tooltip: 'Remove from favourites',
              icon: const Icon(Icons.favorite),
              onPressed: () => onFavouriteChanged(item),
            ),
          ),
      ],
    );
  }
}
