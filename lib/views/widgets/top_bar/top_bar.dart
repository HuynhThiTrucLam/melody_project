// lib/src/common_widgets/top_bar.dart

import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTopBar extends StatelessWidget {
  final bool isSearchBar;
  final VoidCallback onBack;
  final Function(String) onSearch;
  final VoidCallback onNotification;

  const CustomTopBar({
    Key? key,
    required this.isSearchBar,
    required this.onBack,
    required this.onSearch,
    required this.onNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true, // Keep top safe area
      bottom: false, // Remove bottom safe area completely
      left: true, // Remove left safe area
      right: true, // Remove right safe area
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 16,
          top: 4, // Reduced padding at top
          bottom: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            if (isSearchBar)
              GoBackButton(onPressed: onBack)
            else
              SvgPicture.asset(ImageTheme.logo, width: 150),

            // Center - Search bar
            if (isSearchBar)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Hero(
                    tag: 'searchBarHero',
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SearchScreen(
                                        initialQuery: "Hot trending",
                                      ),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                var begin = const Offset(0.0, 0.1);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: CustomSearchBar(
                          label: "Hot trending",
                          svgLeftIcon: ImageTheme.topTrendingIcon,
                          backgroundColor: Colors.white,
                          textColor: LightColorTheme.grey,
                          iconColor: LightColorTheme.grey,
                          borderRadius: BorderRadius.circular(50),
                          width: 200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Right side - Notification
            NotificationButton(
              onPressed: onNotification,
              hasNewNotification: true,
            ),
          ],
        ),
      ),
    );
  }
}
