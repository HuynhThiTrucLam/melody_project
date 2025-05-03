import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/artist_list/artist_item.dart';
import 'package:flutter/material.dart';

class LibraryTab extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? singer;
  const LibraryTab({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.singer,
  });

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Text("Đang phát", style: LightTextTheme.headding3),
          const SizedBox(height: 8),
          ArtistItem(
            itemType: ItemType.song,
            name: widget.name ?? "Unknown Artist",
            subText: widget.singer ?? "Unknown Singer",
            avatarUrl:
                widget.imageUrl ?? "https://example.com/default_avatar.png",
            isVerified: true,
          ),

          const SizedBox(height: 32),

          Text("Thêm bài hát vào Playlist", style: LightTextTheme.headding3),
          const SizedBox(height: 16),

          // Playlist
          // Đúng ra là gọi api lấy các playlist của user
          Expanded(
            child: RawScrollbar(
              thumbColor: LightColorTheme.grey.withOpacity(0.2),
              radius: const Radius.circular(20),
              thickness: 2,
              thumbVisibility: true,
              child: ListView(
                children: [
                  ArtistItem(
                    itemType: ItemType.playlist,
                    name: "Playlist của tôi",
                    subText: "10",
                    avatarUrl:
                        widget.imageUrl ??
                        "https://example.com/default_avatar.png",
                    isVerified: true,
                  ),

                  ArtistItem(
                    itemType: ItemType.playlist,
                    name: "Playlist của tôi",
                    subText: "10",
                    avatarUrl:
                        widget.imageUrl ??
                        "https://example.com/default_avatar.png",
                    isVerified: true,
                  ),

                  ArtistItem(
                    itemType: ItemType.playlist,
                    name: "Playlist của tôi",
                    subText: "10",
                    avatarUrl:
                        widget.imageUrl ??
                        "https://example.com/default_avatar.png",
                    isVerified: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
