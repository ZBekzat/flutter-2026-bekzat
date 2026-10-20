import 'package:flutter/material.dart';

import 'data/seed_data.dart';
import 'models/item.dart';
import 'models/profile.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/runs_screen.dart';
import 'routes.dart';
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

  Item _updateRun(Item updatedItem) {
    if (!mounted) {
      return updatedItem;
    }
    setState(() {
      _items = _items
          .map((item) => item.title == updatedItem.title ? updatedItem : item)
          .toList();
    });
    return updatedItem;
  }

  void _openRunDetails(Item item) {
    if (!mounted) {
      return;
    }
    Navigator.pushNamed<void>(
      context,
      Routes.runDetails,
      arguments: RunDetailsArguments(
        item: item,
        profile: _profile,
        onParticipantsChanged: _updateRun,
        onOpenProfile: _openProfile,
        onEditRun: _editRun,
      ),
    );
  }

  Future<Item?> _createRun() async {
    final result = await Navigator.pushNamed<Item>(
      context,
      Routes.runForm,
      arguments: const RunFormArguments(),
    );
    if (!mounted || result == null) {
      return null;
    }
    setState(() {
      _items = [..._items, result];
    });
    return result;
  }

  Future<Item?> _editRun(Item item) async {
    final result = await Navigator.pushNamed<Item>(
      context,
      Routes.runForm,
      arguments: RunFormArguments(item: item),
    );
    if (!mounted || result == null) {
      return null;
    }
    setState(() {
      _items = _items
          .map((run) => run.title == item.title ? result : run)
          .toList();
    });
    return result;
  }

  void _openProfile() {
    if (!mounted) {
      return;
    }
    Navigator.of(context)
        .popUntil((route) => route.settings.name == Routes.home);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedIndex = 2;
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

    if (!mounted || shouldReset != true) {
      return;
    }
    _resetData();
  }

  Widget _selectedScreen(ThemeMode themeMode) => switch (_selectedIndex) {
    0 => RunsScreen(
      items: _items,
      onFavouriteChanged: _toggleFavourite,
      onRunSelected: _openRunDetails,
    ),
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _createRun,
              icon: const Icon(Icons.add),
              label: const Text('New run'),
            )
          : null,
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
