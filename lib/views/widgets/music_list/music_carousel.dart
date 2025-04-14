import 'package:flutter/material.dart';
import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';

class MusicCarousel extends StatelessWidget {
  final List<dynamic> items;
  final MediaType type;
  final String title;

  const MusicCarousel({
    Key? key,
    required this.items,
    required this.type,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // Carousel
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: EdgeInsets.only(
                  right: index != items.length - 1 ? 16 : 0,
                ),
                child: MusicListItem(
                  item: items[index],
                  type: type,
                  onTap: () {
                    // This will be handled by MusicListItem's _handleTap method
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
