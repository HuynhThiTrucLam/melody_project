import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CustomBlock extends StatefulWidget {
  final String title; // Added title parameter
  final String description;

  const CustomBlock({
    super.key,
    required this.title,
    required this.description,
  }); // Constructor with title

  @override
  State<CustomBlock> createState() => _CustomBlockState();
}

class _CustomBlockState extends State<CustomBlock> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: LightColorTheme.mainColor.withOpacity(0.1),
              blurRadius: 12,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title (now using the title passed from the constructor)
            Text(
              widget.title, // Use widget.title to access the passed title
              style: LightTextTheme.headding2.copyWith(
                color: Colors.black,
                fontSize: 30, // Larger font for better impact
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Space between title and content
            // Description
            Text(
              widget.description,
              style: LightTextTheme.paragraph1.copyWith(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
