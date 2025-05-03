import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/UI/block_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter/material.dart';

class AlbumCarousel extends StatelessWidget {
  final String title;
  final List<BlockData> albums;

  const AlbumCarousel({super.key, required this.title, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightColorTheme.black,
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          //height max content
          height: 230, // Slightly increased height to fix overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: albums.length,
            // Add some padding to the left to align with title
            padding: const EdgeInsets.only(left: 0, right: 16),
            physics:
                const BouncingScrollPhysics(), // Adds bounce effect for better UX
            itemBuilder: (context, index) {
              final album = albums[index];
              // Fixed width for each item
              return Container(
                width: MediaQuery.of(context).size.width * 0.45,
                margin: const EdgeInsets.only(right: 16),
                child: AlbumCard(album: album),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AlbumCard extends StatelessWidget {
  final BlockData album;

  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(album.avatarUrl, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(height: 6), // Reduced from 8 to 6
        // Album Name (Title)
        Text(
          album.name,
          style: const TextStyle(
            fontSize: 15, // Reduced from 16
            fontWeight: FontWeight.bold,
            color: LightColorTheme.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 2), // Reduced from 4 to 2
        // Album Subtitle
        // Listens
        Row(
          children: [
            Icon(Icons.headphones, color: LightColorTheme.grey, size: 10),
            const SizedBox(width: 4),
            Text(
              '${formatListenerCount(int.parse(album.listener))} lượt nghe',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: LightColorTheme.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
