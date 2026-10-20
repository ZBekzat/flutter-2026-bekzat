import 'package:flutter/material.dart';

import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.listsCount,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final Profile profile;
  final int listsCount;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  static final _groupPattern = RegExp(r"^[A-Za-z0-9][A-Za-z0-9 '-]{1,39}$");

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _groupController = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.name != widget.profile.name) {
      _nameController.text = widget.profile.name;
    }
    if (oldWidget.profile.group != widget.profile.group) {
      _groupController.text = widget.profile.group;
    }
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    widget.onProfileChanged(
      Profile(
        name: _nameController.text.trim(),
        group: _groupController.text.trim(),
      ),
    );
  }

  String? _validateGroup(String? value) {
    final group = value?.trim() ?? '';
    if (group.isEmpty) {
      return 'Enter a running group.';
    }
    if (!_groupPattern.hasMatch(group)) {
      return 'Use 2–40 letters, numbers, spaces, apostrophes, or hyphens.';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Your profile', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('You are on ${widget.listsCount} lists'),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Name'),
                onFieldSubmitted: (_) => _saveProfile(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _groupController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Running group'),
                validator: _validateGroup,
                onFieldSubmitted: (_) => _saveProfile(),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _saveProfile,
                  child: const Text('Save profile'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('System'),
              selected: widget.themeMode == ThemeMode.system,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.system),
            ),
            ChoiceChip(
              label: const Text('Light'),
              selected: widget.themeMode == ThemeMode.light,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.light),
            ),
            ChoiceChip(
              label: const Text('Dark'),
              selected: widget.themeMode == ThemeMode.dark,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.dark),
            ),
          ],
        ),
      ],
    );
  }
}
