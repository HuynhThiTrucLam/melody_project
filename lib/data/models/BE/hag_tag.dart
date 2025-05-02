class HagTag {
  final String id;
  final String name;
  final String description;

  HagTag({required this.id, required this.name, required this.description});

  factory HagTag.fromJson(Map<String, dynamic> json) {
    return HagTag(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

final List<HagTag> mockHagTags = [
  HagTag(
    id: '1',
    name: 'Chill',
    description: 'Relaxing music to calm your mind.',
  ),
  HagTag(
    id: '2',
    name: 'Workout',
    description: 'High-energy tracks to fuel your exercise.',
  ),
  HagTag(
    id: '3',
    name: 'Focus',
    description: 'Instrumental tunes to help you concentrate.',
  ),
  HagTag(
    id: '4',
    name: 'Party',
    description: 'Upbeat hits to get the party started.',
  ),
];
