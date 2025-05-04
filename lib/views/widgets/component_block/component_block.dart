import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/component_block/more_tab.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';

class BlockItem extends StatelessWidget {
  final int? no;
  final String? id;
  final String imageUrl;
  final String title;
  final dynamic subtext;

  final String shapeOfImage;
  final bool showNo;
  final bool showButton;
  final bool showPlayButton;
  final bool showInfor;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onInfoPressed;

  const BlockItem({
    super.key,
    this.no,
    this.id,
    required this.imageUrl,
    required this.title,
    required this.subtext,
    required this.shapeOfImage,
    this.showNo = false,
    this.showButton = false,
    this.showPlayButton = false,
    this.showInfor = false,
    this.onButtonPressed,
    this.onPlayPressed,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: fullWidth(context),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: LightColorTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: LightColorTheme.black.withOpacity(0.1),
            blurRadius: 2,

            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        child: Row(
          children: [
            // No. of the item
            if (showNo && no != null) ...[
              Text(
                '$no',
                style: LightTextTheme.regular.copyWith(
                  fontSize: 14,
                  color: LightColorTheme.grey,
                ),
              ),
              const SizedBox(width: 12),
            ],

            // if shapeOfImage == 'circle'
            if (shapeOfImage == 'circle') ...[
              Stack(
                children: [
                  ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Show crown icon for #1 item
                  if (no == 1)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.amber[700],
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ] else if (shapeOfImage == 'square') ...[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Show crown icon for #1 item
                  if (no == 1)
                    Positioned(
                      top: -10, // Reduced from -10 to -5
                      right: -10, // Reduced from -10 to -5
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: LightColorTheme.mainColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),

                        child: Icon(
                          Icons.emoji_events_rounded,

                          color: LightColorTheme.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ],

            const SizedBox(width: 12),

            // Song title and subtext
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: LightTextTheme.headding3.copyWith(
                      fontSize: 14,
                      color: LightColorTheme.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  //If subtext is a string , display the 'Luot nghe'
                  if (subtext is String) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtext,
                      style: LightTextTheme.medium.copyWith(
                        fontSize: 12,
                        color: LightColorTheme.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else if (subtext is int) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.headphones,
                          color: LightColorTheme.grey,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${formatListenerCount(int.parse(subtext.toString()))} lượt nghe', // Convert listener to int
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: LightColorTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            if (showButton) ...[
              const SizedBox(width: 8),
              TagButton(
                label: 'Xem thêm',
                backgroundColor: LightColorTheme.mainColor,
                textColor: LightColorTheme.white,
                borderRadius: BorderRadius.circular(24),
                onClick:
                    onButtonPressed != null ? (_) => onButtonPressed!() : null,
              ),
            ],

            if (showInfor) ...[
              IconButton(
                onPressed: () {
                  // Handle more button tap - show modal bottom sheet
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder:
                        (context) => MoreTab(
                          id: id,
                          name: title,
                          imageUrl: imageUrl,
                          subtext: subtext,
                        ),
                  );

                  // Call the provided callback if available
                  if (onInfoPressed != null) {
                    onInfoPressed!();
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: LightColorTheme.grey,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
