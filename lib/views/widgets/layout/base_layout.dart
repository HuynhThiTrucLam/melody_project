import 'package:MELODY/views/widgets/bottom_nav/bottom_bar.dart';
import 'package:MELODY/views/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final bool isSearchBar;
  final bool? isHeader;
  final String? headerTitle;
  final bool showTopBar;
  final bool showBottomNav;
  final VoidCallback? onNotification;
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;
  final bool isTypingEnabled; // whether the search bar is editable
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onBack;

  const BaseLayout({
    Key? key,
    required this.child,
    this.isSearchBar = true,
    this.showTopBar = true,
    this.showBottomNav = true,
    this.isHeader,
    this.headerTitle,
    this.onNotification,
    this.searchController,
    this.isTypingEnabled = false,
    this.onSearch,
    this.onBack,
    required this.currentIndex,
    required this.onNavigationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          showTopBar
              ? CustomTopBar(
                isSearchBar: isSearchBar,
                isHeader: isHeader,
                headerTitle: headerTitle,
                isTypingEnabled: isTypingEnabled,
                searchController: searchController,
                onBack: onBack ?? () => Navigator.of(context).pop(),
                onSearch: onSearch ?? (query) => print(query),
                onNotification:
                    onNotification ?? () => print("Tapped notification"),
              )
              : null,

      body: child,
      extendBody: showBottomNav, // Only extend body if showing bottom nav
      bottomNavigationBar:
          showBottomNav
              ? AnimatedNotchBottomNav(
                currentIndex: currentIndex,
                onTap: onNavigationTap,
              )
              : null,
    );
  }
}
