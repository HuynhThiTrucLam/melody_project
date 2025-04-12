import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TagButton extends StatefulWidget {
  final String label;
  final double? width; // still optional
  final Color? backgroundColor;
  final Color? textColor;
  final double textSize;
  final double? fontWeight;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final Function(String)? onClick;

  const TagButton({
    Key? key,
    required this.label,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.fontWeight,
    this.textSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.borderRadius,
    this.onClick,
  }) : super(key: key);

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick!(
            widget.label,
          ); // Call the onClick callback with the label
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(0.95),
        width: widget.width,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: LightColorTheme.grey.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor ?? LightColorTheme.grey,
                fontSize: widget.textSize,
                fontWeight:
                    widget.fontWeight != null
                        ? LightTextTheme.bold.fontWeight
                        : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
