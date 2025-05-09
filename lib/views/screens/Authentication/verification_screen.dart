import 'dart:async';
import 'package:MELODY/core/models/otp_type.dart';
import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Authentication/phone_sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/success_screen.dart';
import 'package:MELODY/views/screens/Authentication/forgot_password_screen.dart';
import 'package:MELODY/views/screens/Authentication/reset_password_screen.dart';
import 'package:MELODY/views/screens/Authentication/sign_up_sceen.dart';
import 'package:MELODY/views/screens/Introduction_screen/user_direction_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A screen that allows users to enter the verification code sent to their phone.
///
/// This screen is shown after the user enters their phone number in the
/// [PhoneSignInScreen]. It includes a set of input fields for the verification code,
/// a timer for code expiration, and options to resend the code or go back.
class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final OtpType otpType;
  const VerificationScreen({
    required this.phoneNumber,
    required this.countryCode,
    this.otpType = OtpType.signIn, // Default to signIn
    super.key,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  // Controllers for the verification code input fields
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Timer for code expiration
  Timer? _timer;
  int _secondsRemaining = 60; // 1 minute countdown
  bool _isResendEnabled = false;
  String? _verificationError;
  bool _isVerifying = false; // Loading state for verification process

  // Animation controller for error shake effect
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Initialize shake animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.1, 0.0),
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      }
    });

    // Add listeners to focus nodes and controllers
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        setState(() {}); // Rebuild to update the focused input field
      });

      _codeControllers[i].addListener(() {
        // Auto-advance to next field when a digit is entered
        if (_codeControllers[i].text.isNotEmpty && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
        setState(() {}); // Update UI to reflect filled state
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildInstructionText(),
                    const SizedBox(height: 24),
                    _buildVerificationCodeInput(),
                    const SizedBox(height: 16),
                    if (_verificationError != null) _buildErrorMessage(),
                    const SizedBox(height: 16),
                    _buildResendTimer(),
                    const SizedBox(height: 24),
                    _buildVerifyButton(),
                  ],
                ),
              ),
            ),
            if (_isVerifying) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // void handleGoBack(BuildContext context) {
    //   var nextScreen =
    //       widget.otpType == OtpType.signIn
    //           ? const PhoneSignInScreen()
    //           : widget.otpType == OtpType.signUp
    //           ? const SignUpScreen()
    //           : const ForgotPasswordScreen();
    //   Navigation.navigateTo(context, nextScreen, true);
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            // InkWell(
            //   onTap: () => handleGoBack(context),
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(color: Colors.grey.shade300),
            //     ),
            //     child: const Icon(Icons.arrow_back, size: 20),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 80),
        Center(
          child: Text(
            'Verification code',
            style: LightTextTheme.headding1.copyWith(
              color: LightColorTheme.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nhập mã xác thực đã được gửi đến',
          style: LightTextTheme.paragraph2.copyWith(
            color: LightColorTheme.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.countryCode} ${widget.phoneNumber}',
          style: LightTextTheme.paragraph2.copyWith(
            color: LightColorTheme.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerificationCodeInput() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _shakeAnimation.value,
          child: child!,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) => _buildDigitInput(index)),
      ),
    );
  }

  Widget _buildDigitInput(int index) {
    final bool isFilled = _codeControllers[index].text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color:
            isFilled
                ? LightColorTheme.mainColor.withOpacity(0.05)
                : Colors.white,
        borderRadius: BorderRadius.circular(300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border:
            _focusNodes[index].hasFocus
                ? Border.all(color: LightColorTheme.mainColor, width: 2)
                : isFilled
                ? Border.all(
                  color: LightColorTheme.mainColor.withOpacity(0.3),
                  width: 1,
                )
                : Border.all(
                  color: LightColorTheme.grey.withOpacity(0.1),
                  width: 1,
                ),
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        enabled: !_isVerifying, // Disable input during verification
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 2, top: 8),
        ),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: LightColorTheme.black,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // Clear verification error when user types
          if (_verificationError != null) {
            setState(() {
              _verificationError = null;
            });
          }

          // Provide subtle feedback when typing
          HapticFeedback.selectionClick();

          // Handle backspace (move to previous field)
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto-submit when all digits are entered
          if (index == 5 && value.isNotEmpty) {
            _verifyCode();
          }
        },
        onTap: () {
          // Provide haptic feedback when tapped
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        _verificationError!,
        style: TextStyle(
          color: Colors.red.shade400,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResendTimer() {
    String formattedTime = '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return Center(
      child: Column(
        children: [
          Text(
            'Không nhận được mã?',
            style: LightTextTheme.paragraph3.copyWith(
              color: LightColorTheme.grey,
            ),
          ),
          const SizedBox(height: 8),
          _isResendEnabled
              ? GestureDetector(
                onTap: _resendCode,
                child: Text(
                  'Gửi lại mã',
                  style: LightTextTheme.paragraph3.copyWith(
                    color: LightColorTheme.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gửi lại mã sau ',
                    style: LightTextTheme.paragraph3.copyWith(
                      color: LightColorTheme.grey,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: LightTextTheme.paragraph3.copyWith(
                      color: LightColorTheme.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Future<void> _resendCode() async {
    // Show loading indicator
    setState(() {
      _isResendEnabled = false;
    });

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if still mounted before proceeding
      if (!mounted) return;

      // TODO: Implement actual code resend logic
      // This would typically involve calling your backend API

      // Reset timer and disable resend button
      setState(() {
        _secondsRemaining = 60;
      });

      // Start timer again
      _startTimer();

      // Clear any existing verification error
      if (_verificationError != null) {
        setState(() {
          _verificationError = null;
        });
      }

      // Clear input fields
      for (var controller in _codeControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      // Show a confirmation message with better styling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Mã xác thực mới đã được gửi đến số điện thoại của bạn',
            ),
            backgroundColor: LightColorTheme.mainColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        setState(() {
          _isResendEnabled = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không thể gửi lại mã. Vui lòng thử lại sau.'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  Future<void> _verifyCode() async {
    // Don't proceed if already verifying
    if (_isVerifying) return;

    // Get the complete verification code
    final code = _codeControllers.map((controller) => controller.text).join();

    // Validate code length
    if (code.length != 4) {
      // Shake animation for incomplete code
      _shakeController.forward(from: 0.0);
      HapticFeedback.mediumImpact();

      setState(() {
        _verificationError = 'Vui lòng nhập đủ 4 chữ số';
      });
      return;
    }

    // Set loading state
    setState(() {
      _isVerifying = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if still mounted before proceeding
      if (!mounted) return;

      // TODO: Implement actual verification logic
      // This would typically involve calling your backend API to verify the code

      // For demonstration, we'll simulate verification with a simple check
      // In a real app, replace this with your actual verification logic
      if (code != '1234') {
        // Shake animation for incorrect code
        _shakeController.forward(from: 0.0);
        HapticFeedback.heavyImpact();

        if (mounted) {
          setState(() {
            _verificationError = 'Mã xác thực không chính xác';
            _isVerifying = false;
          });

          // Clear the input fields after a short delay
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              for (var controller in _codeControllers) {
                controller.clear();
              }
              _focusNodes[0].requestFocus();
            }
          });
        }
        return;
      }

      // Verification successful
      // Show success message with animation
      if (mounted) {
        if (widget.otpType == OtpType.signIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xác thực thành công'),
              backgroundColor: LightColorTheme.mainColor,
              duration: Duration(seconds: 1),
            ),
          );

          // Navigate to the success screen after successful sign in verification
          await Future.delayed(const Duration(milliseconds: 200));
          if (!mounted) return;

          Navigation.navigateTo(context, const SuccessScreen(), true);
        } else if (widget.otpType == OtpType.resetPassword) {
          // Navigate to the reset password screen after successful verification
          await Future.delayed(const Duration(milliseconds: 200));
          if (!mounted) return;

          Navigation.navigateTo(
            context,
            ResetPasswordScreen(phoneNumber: widget.phoneNumber),
            false,
          );
        } else if (widget.otpType == OtpType.signUp) {
          // Navigate to the user direction screen after successful verification for signup
          await Future.delayed(const Duration(milliseconds: 200));
          if (!mounted) return;

          Navigation.navigateTo(
            context,
            const SuccessScreen(
              title: "Chào mừng bạn!",
              description: "Hãy cùng khám phá thế giới âm nhạc với chúng tôi!",
              buttonText: "Bắt đầu ngay",
              isSignUp: true,
            ),
            true,
          );
        }
      }
    } catch (e) {
      // Handle any errors
      // Shake animation for error
      if (mounted) {
        _shakeController.forward(from: 0.0);
        HapticFeedback.heavyImpact();

        print('ERROR: _verifyCode: $e');
        setState(() {
          _verificationError = 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
          _isVerifying = false;
        });
      }
    }
  }

  Widget _buildVerifyButton() {
    return CustomButton(
      hintText: _isVerifying ? 'Đang xác thực...' : 'Xác thực',
      isPrimary: true,
      isLoading: false,
      onPressed: _isVerifying ? null : _verifyCode,
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
}
