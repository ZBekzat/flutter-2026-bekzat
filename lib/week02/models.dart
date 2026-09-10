class Author {
  final String name;
  final String? country;

  const Author({
    required this.name,
    this.country,
  });

  @override
  String toString() => '$name (${country ?? 'unknown'})';
}




enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  factory Genre.fromString(String? raw) {
    return switch (raw) {
      'craft' => Genre.craft,
      'theory' => Genre.theory,
      _ => Genre.unknown,
    };
  }
}