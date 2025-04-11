// lib/src/common_widgets/search_bar.dart

import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatelessWidget {
  final String label;
  final IconData? leftIcon; // optional now
  final String? svgLeftIcon;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomSearchBar({
    Key? key,
    required this.label,
    this.leftIcon,
    this.svgLeftIcon,
    this.height = 48,
    this.width = double.infinity,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(initialQuery: "Hot trending"),
          ),
        );
      },
      child: Container(
        height: height,
        // Don't use infinite width here
        width:
            width != double.infinity ? width : 300, // Provide a fallback value
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: Border.all(color: LightColorTheme.grey, width: 0.5),
        ),
        child: Row(
          children: [
            if (leftIcon != null) ...[
              Icon(leftIcon, color: iconColor),
              const SizedBox(width: 8),
            ] else if (svgLeftIcon != null) ...[
              SvgPicture.asset(svgLeftIcon!, color: iconColor),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor ?? LightColorTheme.grey,
                  fontWeight: LightTextTheme.medium.fontWeight,
                ),
              ),
            ),

            SvgPicture.asset(ImageTheme.searchIcon),
          ],
        ),
      ),
    );
  }
}
