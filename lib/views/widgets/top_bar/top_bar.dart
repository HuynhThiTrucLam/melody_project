// lib/src/common_widgets/top_bar.dart

import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchBar;
  final bool? isHeader; // New parameter
  final String? headerTitle; // New: title text for header
  final VoidCallback onBack;
  final Function(String) onSearch;
  final VoidCallback onNotification;

  final bool isTypingEnabled;
  final TextEditingController? searchController;

  const CustomTopBar({
    Key? key,
    required this.isSearchBar,
    required this.onBack,
    required this.onSearch,
    required this.onNotification,
    this.isTypingEnabled = false,
    this.searchController,
    this.isHeader, // New: default false
    this.headerTitle, // New: optional
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: true,
      right: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 16, top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left
            if (isSearchBar || isHeader == true)
              GoBackButton(onPressed: onBack)
            else
              SvgPicture.asset(ImageTheme.logo, width: 150),

            // Center
            if (isHeader == true)
              Expanded(
                child: Center(
                  child: Text(
                    headerTitle ?? '',
                    style: LightTextTheme.headding1.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else if (isSearchBar)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      isTypingEnabled
                          ? TextField(
                            controller: searchController,
                            onChanged: onSearch,
                            style: TextStyle(color: LightColorTheme.grey),
                            cursorColor: LightColorTheme.grey,
                            decoration: InputDecoration(
                              hintText: "Hot trending",
                              hintStyle: TextStyle(color: LightColorTheme.grey),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(
                                  left: 14,
                                  right: 0,
                                  top: 14,
                                  bottom: 14,
                                ),
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  ImageTheme.topTrendingIcon,
                                  color: LightColorTheme.grey,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.8,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: LightColorTheme.mainColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          )
                          : GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => SearchScreen(
                                        initialQuery: "Hot trending",
                                      ),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    var tween = Tween(
                                      begin: const Offset(0.0, 0.1),
                                      end: Offset.zero,
                                    ).chain(
                                      CurveTween(curve: Curves.easeInOut),
                                    );
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

            // Right
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
