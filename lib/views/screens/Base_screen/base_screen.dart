import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Library_screen/library_screen.dart';
import 'package:MELODY/views/screens/Membership_screen/member_screen.dart';
import 'package:MELODY/views/screens/Profile_screen/profile_screen.dart';
import 'package:MELODY/views/screens/Upload_screen/upload_screen.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:MELODY/core/utils/navigation.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 2; // default to "Home" in center
  int _previousIndex = 2;
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
    return WillPopScope(
      onWillPop: () async {
        // Handle system back button
        if (_currentIndex != 2) {
          // If not on Home tab
          _handleBack(context);
          return false; // Prevent default back behavior
        }
        return true; // Allow app to close if on Home tab
      },
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        // onPageChanged: (index) {
        //   setState(() {
        //     _previousIndex = _currentIndex;
        //     _currentIndex = index;
        //     print("previous index: $_previousIndex");
        //     print("current index: $_currentIndex");
        //   });
        // },
        children: [
          BaseLayout(
            child: const LibraryScreen(),
            isHeader: true,
            headerTitle: "Thư viện",
            isSearchBar: false,
            currentIndex: _currentIndex,
            onNavigationTap: _onNavigationTap,
            onBack: () => _handleBack(context),
          ),
          BaseLayout(
            child: const MemberShipScreen(),
            isHeader: true,
            headerTitle: "Thành viên",
            currentIndex: _currentIndex,
            onNavigationTap: _onNavigationTap,
            onBack: () => _handleBack(context),
          ),
          BaseLayout(
            child: HomeScreen(),
            isSearchBar: false,
            currentIndex: _currentIndex,
            onNavigationTap: _onNavigationTap,
            // No back button for home as it's the root
          ),
          BaseLayout(
            child: const UploadScreen(),
            isHeader: true,
            headerTitle: "Tải nhạc lên",
            currentIndex: _currentIndex,
            onNavigationTap: _onNavigationTap,
            onBack: () => _handleBack(context),
          ),
          BaseLayout(
            child: const ProfileScreen(),
            isHeader: true,
            showBottomNav: false,
            headerTitle: "Tài khoản",
            currentIndex: _currentIndex,
            onNavigationTap: _onNavigationTap,
            onBack: () => _handleBack(context),
            onNotification: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
      print("previous index: $_previousIndex");
      print("current index: $_currentIndex");
    });
    // Jump to the selected page when navigation tab is tapped
    _pageController.jumpToPage(index);
  }

  void _handleBack(BuildContext context) {
    print(_previousIndex);
    _onNavigationTap(_previousIndex);
  }
}
