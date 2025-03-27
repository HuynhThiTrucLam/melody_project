import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String hintText;
  final bool isPrimary;
  final void Function()? onPressed;

  const CustomButton({
    required this.hintText,
    this.isPrimary = true,
    this.onPressed,
    super.key,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.isPrimary ? LightColorTheme.mainColor : Colors.white,
        foregroundColor:
            widget.isPrimary ? Colors.white : LightColorTheme.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        minimumSize: const Size(double.infinity, 55),
        elevation: 0, // Add this to see the color more clearly
        side:
            widget.isPrimary
                ? null
                : BorderSide(color: LightColorTheme.black, width: 1),
      ),
      child: Text(
        widget.hintText,
        textAlign: TextAlign.center,
        style:
            widget.isPrimary
                ? LightTextTheme.bold.copyWith(
                  color: LightColorTheme.white,
                  fontSize: 15,
                )
                : LightTextTheme.semibold.copyWith(
                  color: LightColorTheme.black,
                  fontSize: 15,
                ),
      ),
    );
  }
}
