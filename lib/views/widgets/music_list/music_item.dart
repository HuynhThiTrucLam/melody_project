import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/screens/Album_detail_screen/album_detail.dart';
import 'package:MELODY/views/screens/Music_player/music_player.dart';
import 'package:flutter/material.dart';

enum MediaType { song, album, artist } // Added artist type

class MusicListItem extends StatelessWidget {
  final dynamic item; // Can be MusicData, AlbumData, or ArtistData
  final VoidCallback onTap;
  final MediaType type;
  final bool? isOpenTag;

  const MusicListItem({
    Key? key,
    required this.item,
    required this.onTap,
    required this.type,
    this.isOpenTag = true,
  }) : super(key: key);

  void _handleTap(BuildContext context) {
    if (type == MediaType.song) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  MusicPlayer(musicId: item.id),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else if (type == MediaType.album) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  AlbumDetail(albumId: item.id),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else if (type == MediaType.artist) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract common properties based on item type
    String imageUrl;
    String title;
    String subtitle;
    String countLabel;
    int countValue;

    // Logic for different types
    if (type == MediaType.song) {
      imageUrl = item.albumArt;
      title = item.name;
      subtitle = item.artist;
      countValue = item.listener;
      countLabel = 'lượt nghe';
    } else if (type == MediaType.album) {
      imageUrl = item.coverImage;
      title = item.title;
      subtitle = '${item.songCount} bài hát';
      countValue = item.totalListens;
      countLabel = 'lượt nghe';
    } else {
      // type == MediaType.artist
      imageUrl = item.avatarUrl;
      title = item.name;
      subtitle = item.isVerified ? 'Verified Artist' : 'Artist';
      countValue = item.listeners;
      countLabel = 'lượt nghe';
    }

    return GestureDetector(
      onTap: () => _handleTap(context),
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
                    type == MediaType.song
                        ? Icons.music_note
                        : type == MediaType.album
                        ? Icons.album
                        : Icons.person,
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
                      if (isOpenTag == true) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: LightColorTheme.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            type == MediaType.song
                                ? 'Bài hát'
                                : type == MediaType.album
                                ? 'Album'
                                : 'Nghệ sĩ', // Artist label
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: LightColorTheme.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

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

                  // Subtitle (artist, song count, or artist status)
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
