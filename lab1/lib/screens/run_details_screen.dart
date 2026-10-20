import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/item.dart';
import '../routes.dart';
import '../utils/format.dart';

class RunDetailsScreen extends StatefulWidget {
  const RunDetailsScreen({super.key, required this.arguments});

  final RunDetailsArguments arguments;

  @override
  State<RunDetailsScreen> createState() => _RunDetailsScreenState();
}

class _RunDetailsScreenState extends State<RunDetailsScreen> {
  late Item _item;
  late final Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _item = widget.arguments.item;
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h';
    }
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get _countdownLabel => switch (_item.countdown) {
    Upcoming(:final remaining) => 'Starts in ${_formatDuration(remaining)}',
    Started(:final elapsed) => 'In progress · ${_formatDuration(elapsed)} ago',
    Ended() => 'Run ended',
  };

  String get _profileName => widget.arguments.profile.name.trim();

  bool _matchesProfileName(String name) {
    if (_profileName.isEmpty) {
      return false;
    }

    final normalizedName = name.trim().toLowerCase();
    final normalizedProfile = _profileName.toLowerCase();
    final firstName = normalizedProfile.split(RegExp(r'\s+')).first;
    return normalizedName == normalizedProfile || normalizedName == firstName;
  }

  bool get _isRegistered => _item.participants.any(_matchesProfileName);

  void _openProfileFromSnackBar() {
    if (!mounted) {
      return;
    }
    widget.arguments.onOpenProfile();
  }

  Future<void> _changeParticipation() async {
    if (_profileName.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Add your name to your profile first.'),
            action: SnackBarAction(
              label: 'Go to Profile',
              onPressed: _openProfileFromSnackBar,
            ),
          ),
        );
      return;
    }

    final wasRegistered = _isRegistered;
    if (_item.isFull && !wasRegistered) {
      return;
    }

    final actionName = wasRegistered ? 'Leave run' : 'Join run';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionName?'),
        content: Text(
          wasRegistered
              ? 'Remove $_profileName from the participant list?'
              : 'Add $_profileName to the participant list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(actionName),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) {
      return;
    }

    final participants = List<String>.from(_item.participants);
    if (wasRegistered) {
      participants.removeWhere(_matchesProfileName);
    } else {
      participants.add(_profileName);
    }

    final updatedItem = widget.arguments.onParticipantsChanged(
      _item.copyWith(participants: participants),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _item = updatedItem;
    });
  }

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/run_header.png', fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.scrim.withValues(alpha: 0.05),
                  colors.scrim.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _item.category.color(colors),
                      foregroundColor: colors.surface,
                      child: Icon(_item.category.icon),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _item.category.label,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: colors.surface),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _countdownLabel,
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: colors.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(color: colors.surface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(BuildContext context) {
    final description = _item.description;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _DetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'Date and time',
          value: formatDateTime(_item.dateTime),
        ),
        _DetailRow(
          icon: _item.isOnline ? Icons.videocam_outlined : Icons.place_outlined,
          label: _item.isOnline ? 'Meeting link' : 'Meeting point',
          value: _item.location,
        ),
        _DetailRow(
          icon: Icons.people_outline,
          label: 'Places',
          value:
              '${_item.places.taken} joined · ${_item.places.free} free of ${_item.participantLimit}',
        ),
        if (description != null && description.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'About this run',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    );
  }

  Widget _buildParticipants(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_item.participants.isEmpty) {
      return const Center(child: Text('No participants yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _item.participants.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final name = _item.participants[index];
        final isCurrentUser = _matchesProfileName(name);

        return ListTile(
          tileColor: isCurrentUser ? colors.primaryContainer : null,
          leading: CircleAvatar(
            backgroundColor: isCurrentUser
                ? colors.primary
                : colors.surfaceContainerHighest,
            foregroundColor: isCurrentUser
                ? colors.onPrimary
                : colors.onSurfaceVariant,
            child: Text(
              name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
            ),
          ),
          title: Text(
            name,
            style: isCurrentUser
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          ),
          subtitle: isCurrentUser ? const Text('You') : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRegistered = _isRegistered;
    final isDisabled = _item.isFull && !isRegistered;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Run details'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'About'),
              Tab(text: 'Participants (${_item.count})'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: TabBarView(
                children: [_buildAbout(context), _buildParticipants(context)],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isDisabled ? null : _changeParticipation,
                icon: Icon(isRegistered ? Icons.logout : Icons.directions_run),
                label: Text(
                  isRegistered
                      ? 'Leave run'
                      : isDisabled
                      ? 'Run is full'
                      : 'Join run',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
