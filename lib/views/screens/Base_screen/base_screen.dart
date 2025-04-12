// lib/views/screens/base_screen.dart
import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Library_screen/library_screen.dart';
import 'package:MELODY/views/screens/Membership_screen/membership_screen.dart';
import 'package:MELODY/views/screens/Profile_screen/profile_screen.dart';
import 'package:MELODY/views/screens/Upload_screen/upload_screen.dart';
import 'package:MELODY/views/widgets/bottom_nav/bottom_nav.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';
// import 'package:MELODY/widgets/bottom_nav.dart';
// import 'package:MELODY/views/layouts/base_layout.dart';
// import 'package:MELODY/views/screens/library_screen.dart';
// import 'package:MELODY/views/screens/members_screen.dart';
// import 'package:MELODY/views/screens/home_screen.dart';
// import 'package:MELODY/views/screens/upload_screen.dart';
// import 'package:MELODY/views/screens/profile_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 2; // default to "Home" in center

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BaseLayout(child: const LibraryScreen(), isSearchBar: false),
      BaseLayout(child: const MembershipScreen()),
      BaseLayout(child: HomeScreen(), isSearchBar: false),
      BaseLayout(child: const UploadScreen()),
      BaseLayout(
        child: const ProfileScreen(),
        onNotification: () {
          // Handle notification icon tap
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
