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
  }) : super(key: key);

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        width: widget.width,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: LightColorTheme.grey.withOpacity(_isPressed ? 0.1 : 0.2),
              blurRadius: _isPressed ? 1 : 2,
              offset: _isPressed ? const Offset(0, 0) : const Offset(0, 0),
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
