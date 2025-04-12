import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_item.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final List<String> labels = [
    'Thư viện',
    'Thành viên',
    '',
    'Đăng tải',
    'Tài khoản',
  ];

  final List<String> icons = [
    ImageTheme.libraryIcon,
    ImageTheme.membershipIcon,
    ImageTheme.homeIcon,
    ImageTheme.uploadIcon,
    ImageTheme.accountIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none, // allow overflow
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 10, bottom: 32),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF111111), Color(0xFF777777)],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              if (index == 2) {
                return const SizedBox(width: 60); // space for center icon
              }
              return NavItem(
                iconPath: icons[index],
                label: labels[index],
                isSelected: widget.currentIndex == index,
                onTap: () => widget.onTap(index),
                isSvg: true, // tell NavItem to use SvgPicture
              );
            }),
          ),
        ),
        Positioned(
          bottom: 60, // position above container
          child: GestureDetector(
            onTap: () => widget.onTap(2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  icons[2],
                  color:
                      widget.currentIndex == 2 ? Colors.white : Colors.white54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
