import 'package:flutter/material.dart';

import '../models/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final Profile profile;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(profile.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(profile.group),
        const SizedBox(height: 32),
        Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('System'),
              selected: themeMode == ThemeMode.system,
              onSelected: (_) => onThemeModeChanged(ThemeMode.system),
            ),
            ChoiceChip(
              label: const Text('Light'),
              selected: themeMode == ThemeMode.light,
              onSelected: (_) => onThemeModeChanged(ThemeMode.light),
            ),
            ChoiceChip(
              label: const Text('Dark'),
              selected: themeMode == ThemeMode.dark,
              onSelected: (_) => onThemeModeChanged(ThemeMode.dark),
            ),
          ],
        ),
      ],
    );
  }
}
