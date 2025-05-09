import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/core/services/user_service.dart';
import 'package:MELODY/data/models/BE/user_data.dart';
import 'package:MELODY/views/screens/Authentication/phone_sign_in_screen.dart';
import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
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
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Use Future.microtask to ensure the method runs after the widget is fully built
    Future.microtask(() => _verifyTokenAndInit());
  }

  Future<void> _verifyTokenAndInit() async {
    if (!mounted) return;

    try {
      // First set loading state
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = await _authService.getToken();

      // Handle no token case
      if (token == null || token.isEmpty) {
        print("No valid token found in BaseScreen");
        if (!mounted) return;

        // Navigate to login screen instead of showing error
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroductionScreen()),
        );
        return;
      }

      // Load user data
      final userData = await _userService.getUserDataFromToken();
      if (userData == null && mounted) {
        setState(() {
          _errorMessage = "Couldn't load user data. Please try again.";
          _isLoading = false;
        });
        return;
      }

      // Success case
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error initializing BaseScreen: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "An error occurred. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  void _retryLoading() {
    _verifyTokenAndInit();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or error state
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading your music...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    // Show error with retry option
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _retryLoading,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

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
            child: ProfileScreen(),
            isHeader: true,
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
