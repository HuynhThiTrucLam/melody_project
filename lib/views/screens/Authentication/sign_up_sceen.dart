import 'package:MELODY/auth/google_auth_service.dart';
import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/core/models/country_code.dart';
import 'package:MELODY/core/models/otp_type.dart';
import 'package:MELODY/core/services/country_code_service.dart';
import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Authentication/success_screen.dart';
import 'package:MELODY/views/screens/Authentication/verification_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/user_direction_screen.dart';
import 'package:MELODY/views/widgets/custom_input/custom_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_input/default_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';

/// A screen that allows users to sign in to the MELODY app.
///
/// This screen includes username and password fields, forgot password link,
/// primary sign-in button, and alternative sign-in methods (phone and Google).
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  List<CountryCode> _countryCodes = [];
  CountryCode? _selectedCountry;
  String? _phoneError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _acceptTermsError;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _loadCountryCodes();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadCountryCodes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _countryCodes = await CountryCodeService.loadCountryCodes();
      // Set Vietnam (+84) as default selected country
      _selectedCountry = _countryCodes.firstWhere(
        (country) => country.dialCode == '+84',
        orElse: () => _countryCodes.first,
      );
    } catch (e) {
      // Fallback to a default country if loading fails
      _selectedCountry = CountryCode(
        name: 'Vietnam',
        dialCode: '+84',
        code: 'VN',
      );
      _countryCodes = [_selectedCountry!];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    _buildSignUpForm(),
                    const SizedBox(height: 16),
                    _buildCheckboxAcceptTerms(),
                    const SizedBox(height: 16),
                    _buildSignUpButton(),
                    const SizedBox(height: 16),
                    _buildAlternativeSignUpOptions(context),
                    const SizedBox(height: 40),
                    _buildSignInPrompt(context),
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const DirectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
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
              Text(
                'Đăng Ký',
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

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputField(
          controller: _usernameController,
          hintText: 'Tên tài khoản',
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
        CustomPhoneInput(
          phoneController: _phoneController,
          countryCodes: _countryCodes,
          selectedCountry: _selectedCountry!,
          onCountryChanged: (CountryCode country) {
            setState(() {
              _selectedCountry = country;
            });
          },
          phoneError: _phoneError,
          hasBorder: false,
          onChanged: (value) {
            setState(() {
              _phoneError = null;
            });
          },
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
          shadowPosition: ShadowPositionType.right,
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
        const SizedBox(height: 16),
        CustomInputField(
          controller: _confirmPasswordController,
          hintText: 'Nhập lại mật khẩu',
          isPassword: _obscureConfirmPassword,
          onChanged: (value) {
            setState(() {
              _confirmPasswordError = null;
            });
          },
          suffixIcon: IconButton(
            icon: SvgPicture.asset(
              _obscureConfirmPassword
                  ? ImageTheme.visibilityOffEye
                  : ImageTheme.visibilityEye,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          shadowPosition: ShadowPositionType.left,
        ),
        if (_confirmPasswordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _confirmPasswordError!,
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

  Future<void> _handleSignUp() async {
    // Reset previous errors
    setState(() {
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _acceptTermsError = null;
      _phoneError = null;
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

    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Vui lòng nhập số điện thoại';
      });
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Vui lòng nhập mật khẩu';
      });
      hasError = true;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
      });
      hasError = true;
    }

    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Mật khẩu không khớp';
      });
      hasError = true;
    }

    if (!_acceptTerms) {
      setState(() {
        _acceptTermsError = 'Vui lòng đồng ý với các điều khoản và điều kiện';
      });
      hasError = true;
    }
    if (hasError) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // TODO: Replace with actual API call
    // Simulating API call for demonstration
    try {
      // Add a delay to simulate network request
      final authen = await AuthService().signUp(
        _usernameController.text,
        _passwordController.text,
        _phoneController.text,
      );

      if (authen == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (!mounted) return;
      // Sign up successful
      setState(() {
        _isLoading = false;
      });
      debugPrint('Signing up: ${_usernameController.text}');
      Navigation.navigateTo(
        context,
        VerificationScreen(
          phoneNumber: _phoneController.text,
          countryCode: _selectedCountry!.dialCode,
          otpType: OtpType.signUp,
        ),
        false,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xảy ra lỗi: ${e.toString()}')));
    }
  }

  Widget _buildSignUpButton() {
    return CustomButton(
      hintText: 'Đăng ký',
      isPrimary: true,
      onPressed: _handleSignUp,
    );
  }

  Widget _buildCheckboxAcceptTerms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                activeColor: LightColorTheme.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Đồng ý với các',
              style: LightTextTheme.paragraph3.copyWith(
                color: LightColorTheme.grey,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Chính sách và Điều khoản',
              style: LightTextTheme.paragraph3.copyWith(
                color: LightColorTheme.mainColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        if (_acceptTermsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              _acceptTermsError!,
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

  Widget _buildAlternativeSignUpOptions(BuildContext context) {
    return Column(
      children: [
        _buildAlternativeSignUpButton(
          icon: Image.asset(ImageTheme.googleAuth),
          text: 'Đăng ký với Google',
          onPressed: () async {
            final authen = await _googleAuthService.signInWithGoogle();
            if (authen != null) {
              await Future.delayed(const Duration(milliseconds: 200));
              if (!mounted) return;
              if (authen.isNewUser == true) {
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

  Widget _buildAlternativeSignUpButton({
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

  Widget _buildSignInPrompt(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Đã có tài khoản? ',
            style: LightTextTheme.paragraph3.copyWith(
              color: LightColorTheme.grey,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigation.navigateTo(context, const SignInScreen(), false);
            },
            child: Text(
              'Đăng nhập ngay',
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
}
