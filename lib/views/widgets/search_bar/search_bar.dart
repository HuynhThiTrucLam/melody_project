import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';

class CustomSearchBar extends StatelessWidget {
  final String label;
  final IconData? leftIcon;
  final String? svgLeftIcon;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final bool isInSearchScreen;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final double iconSize;
  final Size? svgIconSize;

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
    this.isInSearchScreen = false,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.iconSize = 20,
    this.svgIconSize,
  }) : super(key: key);

  Widget _buildIcon() {
    if (leftIcon != null) {
      return Icon(leftIcon, color: iconColor, size: iconSize);
    } else if (svgLeftIcon != null) {
      return SvgPicture.asset(
        svgLeftIcon!,
        color: iconColor,
        width: svgIconSize?.width ?? iconSize,
        height: svgIconSize?.height ?? iconSize,
      );
    }
    return const SizedBox.shrink();
  }

  BoxDecoration get _decoration => BoxDecoration(
    color: backgroundColor ?? Colors.white,
    borderRadius: borderRadius ?? BorderRadius.circular(1),
    border: Border.all(
      color: LightColorTheme.grey.withOpacity(0.3),
      width: 0.5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isFullWidth = width == double.infinity;

    return GestureDetector(
      onTap:
          !isInSearchScreen
              ? () {
                if (ModalRoute.of(context)?.settings.name != '/search') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: '/search'),
                      builder:
                          (_) =>
                              const SearchScreen(initialQuery: "Hot trending"),
                    ),
                  );
                }
              }
              : null,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height,
        width: isFullWidth ? 300 : width,
        padding: padding,
        decoration: _decoration,
        child: Row(
          children: [
            if (leftIcon != null || svgLeftIcon != null) ...[
              _buildIcon(),
              const SizedBox(width: 8),
            ],
            Expanded(
              child:
                  isInSearchScreen
                      ? TextField(
                        focusNode: focusNode,
                        controller: controller,
                        onChanged: onChanged,
                        style: TextStyle(
                          color: textColor ?? LightColorTheme.grey,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: label,
                          hintStyle: TextStyle(
                            color: textColor ?? LightColorTheme.grey,
                            fontWeight: LightTextTheme.regular.fontWeight,
                          ),
                        ),
                      )
                      : Text(
                        label,
                        style: TextStyle(
                          color: textColor ?? LightColorTheme.grey,
                          fontWeight: LightTextTheme.paragraph3.fontWeight,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
