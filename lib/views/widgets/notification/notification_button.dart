import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:flutter/material.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasNewNotification;

  const NotificationButton({
    required this.onPressed,
    this.hasNewNotification = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45, // Ensure there's enough space
      height: 45,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            ImageTheme.notification,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(
              LightColorTheme.black,
              BlendMode.srcIn,
            ),
          ),

          if (hasNewNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: LightColorTheme.mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
