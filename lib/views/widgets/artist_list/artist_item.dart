import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/BE/playlist_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter/material.dart';

enum ItemType { artist, song, playlist }

// Default album background images for fallback
const List<String> defaultAlbumBackgrounds = [
  'https://i.pinimg.com/736x/41/27/50/412750a66a2acf2bf9bca02120f17186.jpg',
  'https://i.pinimg.com/736x/a3/54/b3/a354b30dc6c3200d52c947aa785a5e49.jpg',
  'https://i.pinimg.com/736x/62/85/a3/6285a33df275eed23bb0e1b4eb310f36.jpg',
];

class ArtistItem extends StatelessWidget {
  final String name;
  final String
  subText; // Followers for artist, singer name for song, album count for playlist
  final String? avatarUrl;
  final bool isVerified;
  final ItemType itemType;

  const ArtistItem({
    Key? key,
    required this.name,
    required this.subText,
    required this.avatarUrl,
    this.isVerified = false,
    this.itemType = ItemType.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            itemType == ItemType.playlist
                ? []
                : [
                  BoxShadow(
                    color: LightColorTheme.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getSubtitleText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    // Get default image URL if avatarUrl is null
    final imageUrl = avatarUrl ?? defaultAlbumBackgrounds[0];

    if (itemType == ItemType.playlist) {
      // For playlist mode, use rectangular image
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // For artist and song modes, use original circular avatar
      return Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          if (isVerified)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
            ),
        ],
      );
    }
  }

  String _getSubtitleText() {
    switch (itemType) {
      case ItemType.artist:
        // For artists, format the follower count
        return '${formatListenerCount(int.parse(subText))} người theo dõi';
      case ItemType.song:
        // For songs, just display the singer name
        return 'Ca sĩ: $subText';
      case ItemType.playlist:
        // For playlists, display the album count
        int albumCount = int.parse(subText);
        return '$albumCount ${albumCount == 1 ? 'album' : 'albums'}';
    }
  }
}
