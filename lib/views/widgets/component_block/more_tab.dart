import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Music_player/music_player.dart';
import 'package:MELODY/views/widgets/component_block/component_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoreTab extends StatefulWidget {
  final String? id;
  final String name;
  final String imageUrl;
  final dynamic subtext;
  const MoreTab({
    super.key,
    this.id,
    required this.name,
    required this.imageUrl,
    required this.subtext,
  });

  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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
          const SizedBox(height: 16),
          BlockItem(
            id: widget.id,
            showNo: false,
            imageUrl: widget.imageUrl,
            title: widget.name,
            subtext: widget.subtext ?? '',
            shapeOfImage: 'square',
            showButton: false,
            showInfor: false,
            onButtonPressed: () {
              print('Button clicked');
            },
            onInfoPressed: () {
              print('More info clicked');
            },
          ),

          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          MusicPlayer(musicId: widget.id!),
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageTheme.playBorderIcon,
                    width: 24,
                    height: 24,
                    color: LightColorTheme.black,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Phát bài hát',
                    style: LightTextTheme.regular.copyWith(
                      fontSize: 16,
                      color: LightColorTheme.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              print('Add to favorite');
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageTheme.libraryIcon,
                    width: 24,
                    height: 24,
                    color: LightColorTheme.black,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thêm vào danh sách phát',
                    style: LightTextTheme.regular.copyWith(
                      fontSize: 16,
                      color: LightColorTheme.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Share button
          GestureDetector(
            onTap: () {
              print('Shared clicked');
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageTheme.shareIcon,
                    width: 24,
                    height: 24,
                    color: LightColorTheme.black,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Chia sẻ bài hát',
                    style: LightTextTheme.regular.copyWith(
                      fontSize: 16,
                      color: LightColorTheme.black,
                    ),
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
