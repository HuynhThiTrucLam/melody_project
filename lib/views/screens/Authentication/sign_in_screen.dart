import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Authentication/forgot_password.dart';
import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:MELODY/views/screens/Authentication/forgot_password_screen.dart';
import 'package:MELODY/views/screens/Authentication/phone_sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/success_screen.dart';
// import 'package:MELODY/views/screens/Sign_in_screen/forgot_password.dart';
// import 'package:MELODY/views/screens/Sign_in_screen/phone_sign_in_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/screens/Authentication/sign_up_sceen.dart';
import 'package:MELODY/views/screens/Introduction_screen/user_direction_screen.dart';
import 'package:flutter/material.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_input/default_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MELODY/auth/google_auth_service.dart';
import 'package:MELODY/auth/auth_service.dart';

/// A screen that allows users to sign in to the MELODY app.
///
/// This screen includes username and password fields, forgot password link,
/// primary sign-in button, and alternative sign-in methods (phone and Google).
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLoginForm(),
                    const SizedBox(height: 16),
                    _buildForgotPassword(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 32),
                    _buildDivider(),
                    const SizedBox(height: 32),
                    _buildAlternativeLoginOptions(context),
                    const SizedBox(height: 40),
                    _buildSignUpPrompt(context),
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
    // void handleGoBack(BuildContext context) {
    //   Navigator.pushReplacement(
    //     context,
    //     PageRouteBuilder(
    //       pageBuilder:
    //           (context, animation, secondaryAnimation) =>
    //               const DirectionScreen(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         const begin = Offset(-1.0, 0.0);
    //         const end = Offset.zero;
    //         const curve = Curves.easeInOut;
    //         var tween = Tween(
    //           begin: begin,
    //           end: end,
    //         ).chain(CurveTween(curve: curve));
    //         var offsetAnimation = animation.drive(tween);
    //         return SlideTransition(position: offsetAnimation, child: child);
    //       },
    //       transitionDuration: const Duration(milliseconds: 300),
    //     ),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GoBackButton(),
        // Row(
        //   children: [
        //     InkWell(
        //       onTap: () => handleGoBack(context),
        //       child: Container(
        //         padding: const EdgeInsets.all(8),
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           border: Border.all(color: Colors.grey.shade300),
        //         ),
        //         child: const Icon(Icons.arrow_back, size: 20),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                'Đăng nhập',
                style: LightTextTheme.headding1.copyWith(
                  color: LightColorTheme.black,
                ),
              ),
              const SizedBox(height: 8),
              SvgPicture.asset(ImageTheme.logo, height: 10.1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputField(
          controller: _usernameController,
          hintText: 'Tên đăng nhập',
          onChanged: (value) {
            setState(() {
              _usernameError = null;
            });
          },
        ),
        if (_usernameError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _usernameError!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        const SizedBox(height: 16),
        CustomInputField(
          controller: _passwordController,
          hintText: 'Mật khẩu',
          isPassword: _obscurePassword,
          onChanged: (value) {
            setState(() {
              _passwordError = null;
            });
          },
          suffixIcon: IconButton(
            icon: SvgPicture.asset(
              _obscurePassword
                  ? ImageTheme.visibilityOffEye
                  : ImageTheme.visibilityEye,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          shadowPosition: ShadowPositionType.left,
        ),
        if (_passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _passwordError!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // TODO: Implement forgot password functionality
          //Navigate to ForGotpass
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPassword()),
          );
        },
        child: Text(
          'Quên mật khẩu?',
          style: LightTextTheme.paragraph3.copyWith(
            color: LightColorTheme.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Reset previous errors
    setState(() {
      _usernameError = null;
      _passwordError = null;
      _isLoading = true;
    });

    // Validate form fields
    bool hasError = false;

    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = 'Vui lòng nhập tên đăng nhập';
      });
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Vui lòng nhập mật khẩu';
      });
      hasError = true;
    }

    if (hasError) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final authen = await AuthService().signIn(
        _usernameController.text,
        _passwordController.text,
      );

      if (authen == null) {
        setState(() {
          _usernameError = 'Tài khoản không tồn tại';
          _isLoading = false;
        });
        return;
      }

      // Login successful
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đăng nhập thành công',
            style: TextStyle(color: LightColorTheme.mainColor),
          ),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          duration: Duration(milliseconds: 1500),
        ),
      );
      debugPrint('Login successful: ${_usernameController.text}');
      Navigation.navigateTo(context, const SuccessScreen(), false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xảy ra lỗi: ${e.toString()}')));
    }
  }

  Widget _buildLoginButton() {
    return CustomButton(
      hintText: 'Đăng nhập',
      isPrimary: true,
      onPressed: _handleLogin,
    );
  }
}

Widget _buildDivider() {
  return Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Hoặc đăng nhập với',
          style: LightTextTheme.paragraph3.copyWith(
            color: LightColorTheme.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const Expanded(child: Divider()),
    ],
  );
}

Widget _buildAlternativeLoginOptions(BuildContext context) {
  void handleNavToPhoneSignInScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PhoneSignInScreen()),
    );
  }

  return Column(
    children: [
      _buildAlternativeLoginButton(
        icon: SvgPicture.asset(ImageTheme.phoneAuth),
        text: 'Số điện thoại',
        onPressed: () => handleNavToPhoneSignInScreen(context),
      ),
      const SizedBox(height: 16),
      _buildAlternativeLoginButton(
        icon: Image.asset(ImageTheme.googleAuth),
        text: 'Tài khoản Google',
        onPressed: () async {
          final result = await GoogleAuthService().signInWithGoogle();
          if (result != null) {
            if (result.isNewUser == true) {
              Navigation.navigateTo(
                context,
                const UserDirectionScreen(),
                false,
              );
            } else {
              Navigation.navigateTo(context, const SuccessScreen(), false);
            }
          }
        },
      ),
    ],
  );
}

Widget _buildAlternativeLoginButton({
  required Widget icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: LightColorTheme.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      minimumSize: const Size(double.infinity, 55),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          text,
          style: LightTextTheme.paragraph3.copyWith(
            color: LightColorTheme.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSignUpPrompt(BuildContext context) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chưa có tài khoản? ',
          style: LightTextTheme.paragraph3.copyWith(
            color: LightColorTheme.grey,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigation.navigateTo(context, const SignUpScreen(), false);
          },
          child: Text(
            'Đăng ký ngay',
            style: LightTextTheme.paragraph3.copyWith(
              color: LightColorTheme.mainColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
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
