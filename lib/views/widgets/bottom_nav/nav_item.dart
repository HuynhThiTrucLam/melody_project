// lib/widgets/nav_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSvg;

  const NavItem({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSvg = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSvg)
              SvgPicture.asset(
                iconPath,
                height: 24,
                color: isSelected ? Colors.white : Colors.white54,
              )
            else
              Image.asset(
                iconPath,
                height: 24,
                color: isSelected ? Colors.white : Colors.white54,
              ),
            if (label.isNotEmpty) const SizedBox(height: 4),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
