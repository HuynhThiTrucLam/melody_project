import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/data/models/UI/album_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter/material.dart';

enum MediaType { song, album }

class MusicListItem extends StatelessWidget {
  final dynamic item; // Can be MusicData or AlbumData
  final VoidCallback onTap;
  final MediaType type;

  const MusicListItem({
    Key? key,
    required this.item,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract common properties based on item type
    final String imageUrl =
        type == MediaType.song ? item.albumArt : item.coverImage;
    final String title = type == MediaType.song ? item.name : item.title;
    final String subtitle =
        type == MediaType.song ? item.artist : '${item.songCount} bài hát';
    final int countValue =
        type == MediaType.song ? item.listener : item.totalListens;
    final String countLabel =
        type == MediaType.song ? 'lượt nghe' : 'lượt nghe';

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: double.infinity,
                  color: LightColorTheme.grey.withOpacity(0.2),
                  child: Icon(
                    type == MediaType.song ? Icons.music_note : Icons.album,
                    size: 50,
                    color: LightColorTheme.grey,
                  ),
                );
              },
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type indicator and count
                  Row(
                    children: [
                      // Media type pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              type == MediaType.song
                                  ? LightColorTheme.mainColor
                                  : LightColorTheme.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type == MediaType.song ? 'SONG' : 'ALBUM',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: LightColorTheme.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Count pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: LightColorTheme.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.headphones,
                              color: LightColorTheme.white,
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${formatListenerCount(countValue)} $countLabel',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: LightColorTheme.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LightColorTheme.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle (artist or song count)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Show release date for albums
                  if (type == MediaType.album) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Phát hành: ${item.releaseDate}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
