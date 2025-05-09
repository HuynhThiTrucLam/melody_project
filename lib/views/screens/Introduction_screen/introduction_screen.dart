import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/views/screens/Introduction_screen/slider_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:MELODY/views/screens/Base_screen/base_screen.dart'; // Import your home screen

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Start time tracking
    final Stopwatch timer = Stopwatch()..start();

    // Parallel tasks: token check and minimum display time
    final token = await _authService.getToken();

    // Calculate remaining time to ensure minimum display duration (3 seconds)
    const minDisplayTime = Duration(seconds: 3);
    final elapsed = timer.elapsed;

    // If less than minDisplayTime has passed, wait for the remainder
    if (elapsed < minDisplayTime) {
      await Future.delayed(minDisplayTime - elapsed);
    }

    if (!mounted) return;

    // Navigate based on token existence
    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BaseScreen()),
      );
    } else {
      // User is not logged in, navigate to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SliderScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation below logo
            Lottie.asset(
              'assets/animations/start-loading.json',
              width: 320,
              height: 320,
              fit: BoxFit.fill,
            ),
            // Logo
            const SizedBox(height: 8),
            SvgPicture.asset("assets/icons/logo.svg", width: 200),
          ],
        ),
      ),
    );
  }
}
