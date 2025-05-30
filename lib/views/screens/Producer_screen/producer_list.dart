import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/Artist_profile.dart';
import 'package:MELODY/views/screens/Top_trending/custom_block.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:flutter/material.dart';

class ProducerList extends StatelessWidget {
  final Future<List<ArtistData>> artistFuture;

  const ProducerList({super.key, required this.artistFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistData>>(
      future: artistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No artist data available'));
        }

        List<ArtistData> artistList = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount:
              artistList.length +
              ((artistList.length + 6) ~/ 6), // block every 6 items
          itemBuilder: (context, index) {
            if (index % 7 == 0) {
              return CustomBlock(
                title: "Nghệ sĩ nổi bật",
                key: Key('block_$index'),
                description:
                    "Nghệ sĩ nổi bật với sự ảnh hưởng mạnh mẽ trong ngành âm nhạc",
              );
            } else {
              int musicIndex = index - (index ~/ 7) - 1;
              // Prevent out-of-range error
              if (musicIndex < 0 || musicIndex >= artistList.length) {
                return const SizedBox.shrink();
              }
              final music = artistList[musicIndex];

              // Determine the rank for the icon (1st, 2nd, 3rd)
              Widget topRankIcon = SizedBox.shrink();

              return Stack(
                children: [
                  MusicListItem(
                    isOpenTag: false,
                    item: music,
                    type: MediaType.artist,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ArtistProfile(artistId: music.id),
                        ),
                      );
                    },
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
