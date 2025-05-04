import 'package:flutter/material.dart';
import 'package:MELODY/data/models/BE/music_data.dart';

class TrendingItem extends StatelessWidget {
  final MusicData music;

  const TrendingItem({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              music.albumArt,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120, // This is adjustable based on content
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              music.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              music.artist,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
