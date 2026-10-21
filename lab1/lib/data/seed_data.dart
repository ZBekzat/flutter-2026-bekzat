import '../models/item.dart';
import '../models/profile.dart';

final sampleProfile = Profile(
  name: 'Zhumamurat Bekzat',
  group: 'Almaty PaceMates',
);

List<Item> createSeedRuns({DateTime? now}) {
  final today = now ?? DateTime.now();
  DateTime at(int days, int hour, [int minute = 0]) =>
      DateTime(today.year, today.month, today.day + days, hour, minute);

  return [
    Item(
      title: 'Easy Morning 5K',
      category: RunCategory.easy,
      dateTime: at(1, 7),
      location: 'First President Park entrance',
      participantLimit: 10,
      participants: ['Amina', 'Dias', 'Mira', 'Arman'],
      description: 'Comfortable conversational pace, around 6:30/km.',
    ),
    Item(
      title: 'Tempo Along the Esentai River',
      category: RunCategory.tempo,
      dateTime: at(2, 18, 30),
      location: 'Esentai River promenade',
      participantLimit: 8,
      participants: ['Amina', 'Nurlan', 'Dana'],
      description: 'Warm up, then 3 × 8 minutes at tempo effort.',
    ),
    Item(
      title: 'Recovery Loop After Work',
      category: RunCategory.recovery,
      dateTime: at(3, 19),
      location: 'Abay Avenue, Central Stadium gate',
      participantLimit: 12,
      participants: ['Mira', 'Dana'],
      description: 'Easy 4 km shakeout with optional walk breaks.',
    ),
    Item(
      title: 'Intervals on the Stadium Track',
      category: RunCategory.intervals,
      dateTime: at(4, 8),
      location: 'Central Stadium track',
      participantLimit: 6,
      participants: ['Dias', 'Arman', 'Amina', 'Mira', 'Dana', 'Nurlan'],
      description: 'Six relaxed 400 m repeats with full recovery.',
    ),
    Item(
      title: 'Big Weekend Long Run to the Reservoir',
      category: RunCategory.longRun,
      dateTime: at(5, 7, 30),
      location: 'Sairan Reservoir, east entrance',
      participantLimit: 14,
      participants: ['Amina', 'Dias', 'Arman', 'Mira', 'Dana'],
      description: 'Build endurance over 14 km; bring water.',
    ),
    Item(
      title: 'Kok-Tobe Sunrise Trail Climb',
      category: RunCategory.trail,
      dateTime: at(7, 6, 45),
      location: 'Kok-Tobe lower cable car station',
      participantLimit: 9,
      participants: ['Nurlan', 'Mira', 'Amina'],
      description: 'Hilly 7 km route; trail shoes recommended.',
    ),
    Item(
      title: 'Lunch Break Easy Miles',
      category: RunCategory.easy,
      dateTime: at(8, 12, 15),
      location: 'Botanical Garden, main gate',
      participantLimit: 7,
      participants: ['Dana', 'Arman'],
      description: 'Short 5 km loop at an easy pace.',
    ),
    Item(
      title: 'Virtual Rainy Day Recovery Run',
      category: RunCategory.recovery,
      dateTime: at(9, 20),
      location: 'https://meet.example.com/pacemate-run',
      participantLimit: 10,
      participants: ['Amina', 'Dias'],
      isOnline: true,
      description: 'Join from your own route and share the easy miles.',
    ),
    Item(
      title: 'Autumn City Park Progression Run for Every Pace Every Sunday',
      category: RunCategory.tempo,
      dateTime: at(11, 9),
      location: 'Panfilov Park, east gate',
      participantLimit: 11,
      participants: ['Mira', 'Dana', 'Nurlan'],
      description: 'Start easy and finish steady over 8 km.',
    ),
    Item(
      title: 'First Run of the Month',
      category: RunCategory.longRun,
      dateTime: at(-2, 8),
      location: 'Park of 28 Panfilov Guardsmen',
      participantLimit: 10,
      participants: ['Amina', 'Dias'],
      description: 'A relaxed 10 km social run.',
    ),
    Item(
      title: 'Easy Five at the River',
      category: RunCategory.easy,
      dateTime: at(13, 7),
      location: 'Esentai River bridge',
      participantLimit: 5,
      participants: ['Amina', 'Dias', 'Mira', 'Arman', 'Dana'],
    ),
    Item(
      title: 'Trail Skills and Hill Strides',
      category: RunCategory.trail,
      dateTime: at(15, 8, 30),
      location: 'Medeu, trailhead plaza',
      participantLimit: 8,
      participants: ['Nurlan', 'Amina', 'Arman'],
      description: 'Practice controlled climbs and descents on a 6 km route.',
    ),
  ];
}

List<Item> sortedRunsByDate(Iterable<Item> items) =>
    items.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

List<Item> runsInCategory(Iterable<Item> items, RunCategory category) =>
    items.where((item) => item.category == category).toList();

List<String> participantNames(Iterable<Item> items) =>
    items.expand((item) => item.participants).toSet().toList();

Map<String, Item> runsByTitle(Iterable<Item> items) =>
    Map.fromEntries(items.map((item) => MapEntry(item.title, item)));

Map<RunCategory, List<Item>> runsGroupedByCategory(Iterable<Item> items) => {
  for (final category in RunCategory.values)
    if (items.any((item) => item.category == category))
      category: items.where((item) => item.category == category).toList(),
};

int totalParticipants(Iterable<Item> items) =>
    items.fold(0, (total, item) => total + item.count);

bool hasUpcomingRun(Iterable<Item> items) => items.any((item) => !item.isPast);
