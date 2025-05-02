import 'package:flutter/material.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoBackButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: Icon(Icons.arrow_back, size: 20, color: LightColorTheme.black),
      ),
    );
  }
}
