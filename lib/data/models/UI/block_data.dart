class BlockData {
  final String name;
  final String subText;
  final String listener; // e.g., singer name
  final String avatarUrl; // cover image
  final bool isVerified;

  BlockData({
    required this.name,
    required this.subText,
    required this.listener, // e.g., singer name
    required this.avatarUrl,
    required this.isVerified,
  });
}
