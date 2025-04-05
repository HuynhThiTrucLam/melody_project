import 'dart:async';

import 'package:MELODY/routes/app_routes.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();
  }

  void _navigateToMainApp() {
    if (mounted) {
      if (widget.isSignUp) {
        // If user just signed up, navigate to user direction screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UserDirectionScreen()),
          (route) => false,
        );
      } else {
        // Otherwise navigate to normal app flow
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.direction,
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: _buildSuccessContent())),
            _buildContinueButton(),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: CustomButton(
        hintText: widget.buttonText,
        isPrimary: true,
        onPressed: _navigateToMainApp,
      ),
    );
  }
}
