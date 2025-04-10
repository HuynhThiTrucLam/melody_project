class TagData {
  final String name;
  final String id;

  TagData({required this.name, required this.id});
}

class TagDataList {
  static final List<TagData> tags = [
    TagData(id: '1', name: 'Tất cả'),
    TagData(id: '2', name: 'Top trending'),
    TagData(id: '3', name: 'Nghệ sĩ/Producer'),
    TagData(id: '4', name: 'Albums'),
    // Add more tags as needed
  ];
}
