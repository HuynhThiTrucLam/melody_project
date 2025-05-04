import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/views/widgets/artist_list/artist_item.dart'; // assumed widget
import 'package:MELODY/views/widgets/component_block/component_block.dart';
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

        return ListView.builder(
          itemCount: artistList.length,
          padding: const EdgeInsets.all(
            8.0,
          ), // Optional: adds padding around the list
          itemBuilder: (context, index) {
            final artist = artistList[index];
            return Column(
              children: [
                BlockItem(
                  imageUrl: artist.avatarUrl,
                  title: artist.name,
                  subtext: artist.listeners,
                  shapeOfImage: "square",
                  showButton: true,
                ),
                const SizedBox(
                  height: 16,
                ), // Gap between items, adjust height as needed
              ],
            );
          },
        );
      },
    );
  }
}
