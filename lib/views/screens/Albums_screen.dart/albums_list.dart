import 'package:MELODY/data/models/BE/album_data.dart';
import 'package:MELODY/views/screens/Album_detail_screen/album_detail.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/Artist_profile.dart';
import 'package:MELODY/views/screens/Top_trending/custom_block.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:flutter/material.dart';

class AlbumsList extends StatelessWidget {
  final Future<List<AlbumData>> albumsFuture;

  const AlbumsList({super.key, required this.albumsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumData>>(
      future: albumsFuture,
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

        List<AlbumData> albumsList = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount:
              albumsList.length +
              ((albumsList.length + 6) ~/ 6), // block every 6 items
          itemBuilder: (context, index) {
            if (index % 7 == 0) {
              return CustomBlock(
                title: "Album nổi bật",
                key: Key('block_$index'),
                description:
                    "Nghệ sĩ nổi bật với sự ảnh hưởng mạnh mẽ trong ngành âm nhạc",
              );
            } else {
              int musicIndex = index - (index ~/ 7) - 1;
              // Prevent out-of-range error
              if (musicIndex < 0 || musicIndex >= albumsList.length) {
                return const SizedBox.shrink();
              }
              final albums = albumsList[musicIndex];

              // Determine the rank for the icon (1st, 2nd, 3rd)
              Widget topRankIcon = SizedBox.shrink();

              return Stack(
                children: [
                  MusicListItem(
                    isOpenTag: false,
                    item: albums,
                    type: MediaType.album,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetail(albumId: albums.id),
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
