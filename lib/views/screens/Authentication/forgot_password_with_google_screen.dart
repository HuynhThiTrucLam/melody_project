import 'package:MELODY/core/models/otp_type.dart';
import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Authentication/forgot_password_screen.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/verification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_input/default_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A screen that allows users to recover their password using their Google email.
///
/// This screen provides an input field for users to enter their email address,
/// which will be used to send a verification code for password reset.
class ForgotPasswordWithGoogleScreen extends StatefulWidget {
  const ForgotPasswordWithGoogleScreen({super.key});

  @override
  State<ForgotPasswordWithGoogleScreen> createState() =>
      _ForgotPasswordWithGoogleScreenState();
}

class _ForgotPasswordWithGoogleScreenState
    extends State<ForgotPasswordWithGoogleScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildInstructionText(),
                    const SizedBox(height: 24),
                    _buildEmailInput(),
                    const SizedBox(height: 16),
                    _buildPhoneOption(),
                    const SizedBox(height: 16),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    void handleGoBack(BuildContext context) {
      Navigation.navigateTo(context, const SignInScreen(), true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => handleGoBack(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              SvgPicture.asset(
                ImageTheme.illustratorSignInWithPhone,
                width: 280,
                height: 280,
              ),
              const SizedBox(height: 24),
              Text(
                'Quên mật khẩu',
                style: LightTextTheme.headding1.copyWith(
                  color: LightColorTheme.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Nhập email đã đăng ký để đặt lại mật khẩu',
      style: LightTextTheme.paragraph2.copyWith(color: LightColorTheme.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 4,
                offset: const Offset(-2, 2),
              ),
            ],
          ),
          child: CustomInputField(
            controller: _emailController,
            hintText: 'melody@gmail.com',
            onChanged: (value) {
              setState(() {
                _emailError = null;
              });
            },
          ),
        ),
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _emailError!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    LightColorTheme.mainColor,
                  ),
                  strokeWidth: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    // Reset previous errors
    setState(() {
      _emailError = null;
      _isLoading = true;
    });

    // Validate email
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Vui lòng nhập email';
        _isLoading = false;
      });
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _emailError = 'Email không hợp lệ';
        _isLoading = false;
      });
      return;
    }

    try {
      // TODO: Implement email verification logic
      // This would typically involve:
      // 1. Sending the email to your backend
      // 2. Backend sends a verification code to the email
      // 3. Navigate to verification code input screen

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mã xác nhận đã được gửi đến email của bạn',
            style: TextStyle(color: LightColorTheme.mainColor),
          ),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _isLoading = false;
      });

      // Navigate to verification code screen with animation
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => VerificationScreen(
                  phoneNumber: _emailController.text, // Using email as ID
                  countryCode: "", // Not needed for email
                  otpType: OtpType.resetPassword,
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xảy ra lỗi: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPhoneOption() {
    return TextButton(
      onPressed: () {
        Navigation.navigateTo(context, const ForgotPasswordScreen(), false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Đặt lại mật khẩu bằng',
            style: LightTextTheme.paragraph2.copyWith(
              color: const Color(0xFF5E5A5A),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Số điện thoại?',
            style: LightTextTheme.paragraph2.copyWith(
              color: const Color(0xFF111111),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return CustomButton(
      hintText: 'Tiếp tục',
      isPrimary: true,
      onPressed: _handleContinue,
    );
  }
}
