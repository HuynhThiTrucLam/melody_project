import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Library_screen/library_screen.dart';
import 'package:MELODY/views/screens/Membership_screen/member_screen.dart';
import 'package:MELODY/views/screens/Profile_screen/profile_screen.dart';
import 'package:MELODY/views/screens/Upload_screen/upload_screen.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 2; // default to "Home" in center
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a PageView to handle page transitions
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      children: [
        BaseLayout(
          child: const LibraryScreen(),
          isHeader: true,
          headerTitle: "Thư viện",
          isSearchBar: false,
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        ),
        BaseLayout(
          child: const MemberShipScreen(),
          isHeader: true,
          headerTitle: "Thành viên",
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        ),
        BaseLayout(
          child: HomeScreen(),
          isSearchBar: false,
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        ),
        BaseLayout(
          child: const UploadScreen(),
          isHeader: true,
          headerTitle: "Tải nhạc lên",
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        ),
        BaseLayout(
          child: const ProfileScreen(),
          // showTopBar: false,
          isHeader: true,
          headerTitle: "Tài khoản",
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
          onNotification: () {
            // Handle notification icon tap
          },
        ),
      ],
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Jump to the selected page when navigation tab is tapped
    _pageController.jumpToPage(index);
  }
}
