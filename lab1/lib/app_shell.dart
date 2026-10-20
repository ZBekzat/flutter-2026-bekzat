import 'package:flutter/material.dart';

import 'data/seed_data.dart';
import 'models/item.dart';
import 'models/profile.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/runs_screen.dart';
import 'theme_mode_scope.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onThemeModeChanged});

  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  List<Item> _items = createSeedRuns();
  Profile _profile = sampleProfile;
  int _selectedIndex = 0;

  void _toggleFavourite(Item changedItem) {
    setState(() {
      _items = _items
          .map(
            (item) => item.title == changedItem.title
                ? item.copyWith(isFavourite: !item.isFavourite)
                : item,
          )
          .toList();
    });
  }

  void _resetData() {
    setState(() {
      _items = createSeedRuns();
      _profile = sampleProfile;
      _selectedIndex = 0;
    });
  }

  Future<void> _showAboutDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About PaceMate'),
        content: const Text(
          'PaceMate helps running club members plan group runs at different '
          'paces and distances.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset PaceMate?'),
        content: const Text(
          'This restores the sample runs and default profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset ?? false) {
      _resetData();
    }
  }

  Widget _selectedScreen(ThemeMode themeMode) => switch (_selectedIndex) {
    0 => RunsScreen(items: _items, onFavouriteChanged: _toggleFavourite),
    1 => FavouritesScreen(items: _items, onFavouriteChanged: _toggleFavourite),
    2 => ProfileScreen(
      profile: _profile,
      themeMode: themeMode,
      onThemeModeChanged: widget.onThemeModeChanged,
    ),
    _ => const SizedBox.shrink(),
  };

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PaceMate')),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('PaceMate Running Club'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmReset();
                },
              ),
            ],
          ),
        ),
      ),
      body: _selectedScreen(themeMode),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_run),
            label: 'Runs',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
