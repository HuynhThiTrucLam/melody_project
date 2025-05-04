import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';

class AnimatedNotchBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedNotchBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedNotchBottomNav> createState() => _AnimatedNotchBottomNavState();
}

class _AnimatedNotchBottomNavState extends State<AnimatedNotchBottomNav> {
  /// Controller to handle bottom bar animation
  late final NotchBottomBarController _controller;

  final List<String> labels = [
    'Thư viện',
    'Thành viên',
    'Trang chủ',
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
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: widget.currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedNotchBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when currentIndex changes from parent
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controller.index = widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: Colors.black,
      showLabel: true,
      removeMargins: true,
      bottomBarHeight: 75.0,
      notchColor: Colors.black,
      showTopRadius: true,
      bottomBarWidth:
          MediaQuery.of(context).size.width - 32.0, // 16.0 left + 16.0 right
      durationInMilliSeconds: 250,
      bottomBarItems: _buildBottomBarItems(),
      onTap: (index) {
        _controller.index = index;
        widget.onTap(index);
      },
      textAlign: TextAlign.center,
      kBottomRadius: 30.0,
      kIconSize: 30.0,
      itemLabelStyle: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: LightTextTheme.medium.fontWeight,
      ),
    );
  }

  List<BottomBarItem> _buildBottomBarItems() {
    return List.generate(5, (index) {
      return BottomBarItem(
        activeItem: Center(
          child: SvgPicture.asset(
            icons[index],
            color: Colors.white,
            width: index == 2 ? 50 : 40, // Larger size for the center item
            height: index == 2 ? 50 : 40, // Larger size for the center item
          ),
        ),
        inActiveItem: Center(
          child: SvgPicture.asset(
            icons[index],
            color: Colors.white,
            width:
                index == 2
                    ? 40
                    : 30, // Smaller size for the inactive center item
            height:
                index == 2
                    ? 40
                    : 30, // Smaller size for the inactive center item
          ),
        ),
        itemLabel: labels[index],
      );
    });
  }
}
