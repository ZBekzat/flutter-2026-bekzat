import 'package:flutter/material.dart';

import 'countdown.dart';

enum RunCategory {
  recovery('Recovery', Icons.spa),
  easy('Easy', Icons.directions_walk),
  tempo('Tempo', Icons.speed),
  intervals('Intervals', Icons.repeat),
  longRun('Long run', Icons.route),
  trail('Trail', Icons.terrain);

  const RunCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    RunCategory.recovery => scheme.tertiary,
    RunCategory.easy => scheme.primary,
    RunCategory.tempo => scheme.secondary,
    RunCategory.intervals => scheme.error,
    RunCategory.longRun => scheme.primaryContainer,
    RunCategory.trail => scheme.tertiaryContainer,
  };
}

class Item {
  Item({
    required this.title,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.participantLimit,
    required List<String> participants,
    this.isOnline = false,
    this.description,
    this.isFavourite = false,
    this.duration = const Duration(hours: 2),
  }) : participants = List.unmodifiable(participants);

  Item.empty()
    : title = '',
      category = RunCategory.easy,
      dateTime = DateTime.fromMillisecondsSinceEpoch(0),
      location = '',
      participantLimit = 0,
      participants = const [],
      isOnline = false,
      description = null,
      isFavourite = false,
      duration = Duration.zero;

  final String title;
  final RunCategory category;
  final DateTime dateTime;
  final String location;
  final int participantLimit;
  final List<String> participants;
  final bool isOnline;
  final String? description;
  final bool isFavourite;
  final Duration duration;

  int get count => participants.length;
  int get freePlaces {
    final available = participantLimit - count;
    return available < 0 ? 0 : available;
  }

  bool get isFull => count >= participantLimit;
  bool get isPast => dateTime.isBefore(DateTime.now());
  ({int taken, int free}) get places => (taken: count, free: freePlaces);
  Countdown get countdown {
    final difference = dateTime.difference(DateTime.now());
    if (difference.isNegative) {
      return difference.abs() >= duration
          ? const Ended()
          : Started(difference.abs());
    }
    return Upcoming(difference);
  }

  bool contains(String name) => participants.any(
    (participant) => participant.toLowerCase() == name.toLowerCase(),
  );

  Item copyWith({
    String? title,
    RunCategory? category,
    DateTime? dateTime,
    String? location,
    int? participantLimit,
    List<String>? participants,
    bool? isOnline,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
    Duration? duration,
  }) => Item(
    title: title ?? this.title,
    category: category ?? this.category,
    dateTime: dateTime ?? this.dateTime,
    location: location ?? this.location,
    participantLimit: participantLimit ?? this.participantLimit,
    participants: participants ?? this.participants,
    isOnline: isOnline ?? this.isOnline,
    description: clearDescription ? null : description ?? this.description,
    isFavourite: isFavourite ?? this.isFavourite,
    duration: duration ?? this.duration,
  );
}
