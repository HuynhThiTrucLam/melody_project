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
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.8),
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              ImageTheme.notification,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                LightColorTheme.black,
                BlendMode.srcIn,
              ),
            ),

            if (hasNewNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: LightColorTheme.mainColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
