import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/component_block/more_tab.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';

class BlockItem extends StatelessWidget {
  final int? no;
  final String id;
  final String imageUrl;
  final String title;
  final String subtext;
  final String shapeOfImage;
  final bool showNo;
  final bool showButton;
  final bool showInfor;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onInfoPressed;

  const BlockItem({
    super.key,
    required this.id,
    this.no,
    required this.imageUrl,
    required this.title,
    required this.subtext,
    required this.shapeOfImage,
    required this.showNo,
    required this.showButton,
    required this.showInfor,
    required this.onButtonPressed,
    required this.onInfoPressed,
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
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
            ] else if (shapeOfImage == 'square') ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
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
                        '${formatListenerCount(int.parse(subtext))} lượt nghe',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: LightColorTheme.grey,
                        ),
                      ),
                    ],
                  ),
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
              ),
            ],

            if (showInfor) ...[
              IconButton(
                onPressed: () {
                  // Handle more button tap - show modal bottom sheet
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true, // Makes it adjustable in height
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
