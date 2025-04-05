import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/screens/Sign_in_screen/forgot_password_screen.dart';
import 'package:MELODY/views/screens/Sign_in_screen/sign_in_sceen.dart';
import 'package:MELODY/views/screens/Sign_in_screen/success_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_input/default_input.dart';
import 'package:flutter/material.dart';

/// A screen that allows users to create a new password after verification.
///
/// This screen is shown after successful OTP verification and allows users
/// to set a new password for their account.
class ResetPasswordScreen extends StatefulWidget {
  /// The phone number that was verified
  final String phoneNumber;

  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildInputFields(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    void handleGoBack(BuildContext context) {
      Navigation.navigateTo(context, const ForgotPasswordScreen(), true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Text(
          'Đặt lại mật khẩu',
          style: TextStyle(
            fontFamily: 'SVN-Gilroy', // Using the font from Figma
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: LightColorTheme.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Đặt lại mật khẩu để đăng nhập cho tài khoản melodySayHi',
          style: TextStyle(
            fontFamily: 'SVN-Gilroy',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xFF5E5A5A), // Using exact color from Figma
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordField(),
        const SizedBox(height: 14),
        _buildConfirmPasswordField(),
        const SizedBox(height: 24),
        _buildPasswordRequirements(),
        const SizedBox(height: 24),
        _buildResetButton(),
      ],
    );
  }

  Widget _buildPasswordField() {
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
            controller: _passwordController,
            hintText: 'Mật khẩu mới',
            isPassword: _obscurePassword,
            onChanged: (value) {
              setState(() {
                _passwordError = null;
              });
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: LightColorTheme.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        if (_passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _passwordError!,
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

  Widget _buildConfirmPasswordField() {
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
            controller: _confirmPasswordController,
            hintText: 'Nhập lại mật khẩu mới',
            isPassword: _obscureConfirmPassword,
            onChanged: (value) {
              setState(() {
                _confirmPasswordError = null;
              });
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: LightColorTheme.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
        ),
        if (_confirmPasswordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _confirmPasswordError!,
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

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '* Mật khẩu nên có ít nhất 8 ký tự.',
          style: TextStyle(
            fontFamily: 'SVN-Gilroy',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xFF5E5A5A),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '* Mật khẩu nên chứa các ký tự:\n\t\t* Chữ cái in hoa (A-Z)\n\t\t* Ký tự đặc biệt (!@#\$%^&*...)\n\t\t* Chữ số (0-9)',
          style: TextStyle(
            fontFamily: 'SVN-Gilroy',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xFF5E5A5A),
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Future<void> _handleResetPassword() async {
    // Reset previous errors
    setState(() {
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Validate password fields
    bool hasError = false;

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Vui lòng nhập mật khẩu mới';
      });
      hasError = true;
    } else if (_passwordController.text.length < 8) {
      // Updated to 8 characters as per design guidance
      setState(() {
        _passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
      });
      hasError = true;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
      });
      hasError = true;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Mật khẩu không khớp';
      });
      hasError = true;
    }

    if (hasError) return;

    // TODO: Implement actual password reset API call
    // For demo purposes, simulate a successful reset

    // Show success dialog
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigation.navigateTo(
      context,
      const SuccessScreen(
        title: 'Thành công đặt lại mật khẩu',
        description:
            'Mật khẩu mới của tài khoản melodySayHi đã được cập nhật thành công',
        buttonText: 'Nghe nhạc ngay thôi',
      ),
      false,
    );
  }

  Widget _buildResetButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomButton(
        hintText: 'Đổi mật khẩu',
        isPrimary: true,
        onPressed: _handleResetPassword,
      ),
    );
  }
}
