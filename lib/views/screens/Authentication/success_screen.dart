import 'dart:async';

import 'package:MELODY/routes/app_routes.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Base_screen/base_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/user_direction_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A screen that shows a success message after user verification.
///
/// This screen is displayed after the user successfully verifies their phone number.
/// It includes an animation, success message, and automatically navigates to the main app
/// after a short delay.
class SuccessScreen extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final String imagePath;
  final bool isSignUp;
  const SuccessScreen({
    super.key,
    this.title = "Chào mừng quay trở lại!",
    this.description =
        "Hãy cùng tận hưởng những giai điệu yêu thích của bạn ngay bây giờ!",
    this.buttonText = "Nghe nhạc ngay thôi",
    this.imagePath = ImageTheme.illustrationSignInSuccess,
    this.isSignUp = false,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _navigationTimer;
  // Animation for fade-out transition
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  // Method to perform smooth transition to destination screen
  void _navigateToMainApp() async {
    // Start fade-out animation
    await _animationController.reverse();

    if (!mounted) return;

    final Widget destinationScreen =
        widget.isSignUp ? const UserDirectionScreen() : const BaseScreen();

    // Use PageRouteBuilder with a custom transition
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => destinationScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade in animation for the destination screen
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    // Make sure to dispose of all resources
    _animationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        // Wrap in FadeTransition for the fade-out effect
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildSuccessContent(), _buildContinueButton()],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success animation
        Center(
          child: SvgPicture.asset(widget.imagePath, width: 311, height: 311),
        ),
        // Success text
        Text(
          widget.title,
          style: LightTextTheme.headding1.copyWith(
            color: LightColorTheme.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            widget.description,
            style: LightTextTheme.paragraph2.copyWith(
              color: LightColorTheme.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: CustomButton(
        hintText: widget.buttonText,
        isPrimary: true,
        onPressed: _navigateToMainApp,
      ),
    );
  }
}
