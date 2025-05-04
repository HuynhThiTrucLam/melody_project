import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/screens/Top_trending/custom_block.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';

class TrendingList extends StatelessWidget {
  final Future<List<MusicData>> topTrendingFuture;

  const TrendingList({super.key, required this.topTrendingFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MusicData>>(
      future: topTrendingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No trending music available'));
        }

        List<MusicData> musicList = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount:
              musicList.length +
              ((musicList.length + 6) ~/ 6), // block every 6 items
          itemBuilder: (context, index) {
            if (index % 7 == 0) {
              return CustomBlock(key: Key('block_$index'));
            } else {
              int musicIndex = index - (index ~/ 7) - 1;
              // Prevent out-of-range error
              if (musicIndex < 0 || musicIndex >= musicList.length) {
                return const SizedBox.shrink();
              }
              final music = musicList[musicIndex];

              // Determine the rank for the icon (1st, 2nd, 3rd)
              Widget topRankIcon = SizedBox.shrink();
              if (musicIndex == 0) {
                topRankIcon = TagButton(
                  label: "Top 1",
                  backgroundColor: LightColorTheme.mainColor,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  fontWeight: 800,
                  borderRadius: BorderRadius.circular(20),
                ); // Top 1
              } else if (musicIndex == 1) {
                topRankIcon = TagButton(
                  label: "Top 2",
                  backgroundColor: LightColorTheme.black,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  fontWeight: 800,
                  borderRadius: BorderRadius.circular(20),
                ); // Top 2
              } else if (musicIndex == 2) {
                topRankIcon = TagButton(
                  label: "Top 3",
                  backgroundColor: LightColorTheme.grey,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  fontWeight: 800,
                  borderRadius: BorderRadius.circular(20),
                ); // Top 3
              }

              return Stack(
                children: [
                  MusicListItem(
                    isOpenTag: false,
                    item: music,
                    type: MediaType.song,
                    onTap: () {},
                  ),
                  Positioned(top: 8, left: 8, child: topRankIcon),
                ],
              );
            }
          },
        );
      },
    );
  }
}
