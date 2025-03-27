import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SliderItem extends StatelessWidget {
  final String imagePath;
  final String text;

  const SliderItem({required this.imagePath, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath, width: 300), // Load image dynamically
          const SizedBox(height: 16),
          SizedBox(
            width: screenWidth * 0.7, // 80% of screen width
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: LightTextTheme.paragraph1,
            ),
          ),
        ],
      ),
    );
  }
}
