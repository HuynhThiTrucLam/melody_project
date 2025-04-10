import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter/material.dart';

class MusicListItem extends StatelessWidget {
  final MusicData music;
  final VoidCallback onTap;

  const MusicListItem({Key? key, required this.music, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Image.network(
              music.albumArt,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
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
                  // Green pill: formatted view count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: LightColorTheme.mainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${formatListenerCount(music.listener)} lượt nghe', // 👈 use helper
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: LightColorTheme.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Song title
                  Text(
                    music.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LightColorTheme.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Artist
                  Text(
                    music.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
