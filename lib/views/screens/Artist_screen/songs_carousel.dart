import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/UI/block_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/widgets/component_block/component_block.dart';
import 'package:flutter/material.dart';

class SongsCarousel extends StatelessWidget {
  final String title;
  final List<BlockData> songs;
  final int maxSongs; // Add parameter to limit number of songs

  const SongsCarousel({
    super.key,
    required this.title,
    required this.songs,
    this.maxSongs = 10, // Default to showing 3 songs
  });

  @override
  Widget build(BuildContext context) {
    // Limit songs to display based on maxSongs parameter
    final displaySongs =
        songs.length > maxSongs ? songs.sublist(0, maxSongs) : songs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with See All button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: LightColorTheme.black,
              ),
            ),

            // Only show if we're limiting songs
            TextButton(
              onPressed: () {
                // Navigate to full song list
                print('See all songs');
              },
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 14,
                  color: LightColorTheme.mainColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Song list with intrinsic height
        ListView.builder(
          shrinkWrap: true, // This makes it take only the height it needs
          physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling within this list
          itemCount: displaySongs.length,
          padding: EdgeInsets.zero, // No padding needed
          itemBuilder: (context, index) {
            final song = displaySongs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: BlockItem(
                no: index + 1,
                id: song.id,
                showNo: false,
                imageUrl: song.avatarUrl,
                title: song.name,
                subtext: song.listener,
                shapeOfImage: 'circle',
                showButton: false,
                showInfor: true,
                onButtonPressed: () {
                  print('Button clicked');
                },
                onInfoPressed: () {
                  print('More info clicked');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
