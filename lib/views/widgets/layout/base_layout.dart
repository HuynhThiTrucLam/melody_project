import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/widgets/bottom_nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:MELODY/views/widgets/top_bar/top_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final bool isSearchBar;
  final VoidCallback? onBack;
  final Function(String)? onSearch;
  final VoidCallback? onNotification;
  final bool showBottomNav;
  final int selectedTab;
  final bool showTopBar; // Add this parameter

  const BaseLayout({
    required this.child,
    this.isSearchBar = false,
    this.onBack,
    this.onSearch,
    this.onNotification,
    this.showBottomNav = true,
    this.selectedTab = 0,
    this.showTopBar = true, // Default to showing top bar
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: Column(
        children: [
          // Only show top bar if showTopBar is true
          if (showTopBar)
            CustomTopBar(
              isSearchBar: isSearchBar,
              onBack: onBack ?? () => Navigator.pop(context),
              onSearch: onSearch ?? (String _) {},
              onNotification: onNotification ?? () {},
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar:
          showBottomNav
              ? CustomBottomNav(
                currentIndex: 2,
                onTap: (index) {
                  // Handle bottom navigation tap
                },
              )
              : null,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  0,
                  'Home',
                  Icons.home_outlined,
                  Icons.home,
                ),
                _buildNavItem(
                  context,
                  1,
                  'Explore',
                  Icons.explore_outlined,
                  Icons.explore,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    IconData icon,
    IconData activeIcon,
  ) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        // Handle navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }
}
