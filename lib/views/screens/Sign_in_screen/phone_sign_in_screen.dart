import 'package:MELODY/core/models/country_code.dart';
import 'package:MELODY/core/services/country_code_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Sign_in_screen/sign_in_sceen.dart';
import 'package:MELODY/views/screens/Sign_in_screen/verification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_input/custom_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A screen that allows users to sign in to the MELODY app using their phone number.
///
/// This screen includes a country code selector, phone number input field,
/// and a continue button to proceed to verification.
class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  List<CountryCode> _countryCodes = [];
  CountryCode? _selectedCountry;
  bool _isLoading = true;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _loadCountryCodes();
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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 14),
                _buildInstructionText(),
                const SizedBox(height: 24),
                _buildPhoneInput(),
                const SizedBox(height: 16),
                _buildContinueButton(),
              ],
            ),
          ),
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
              (context, animation, secondaryAnimation) => const SignInScreen(),
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
              SvgPicture.asset(ImageTheme.illustratorSignInWithPhone),
              const SizedBox(height: 24),
              Text(
                'Đăng nhập',
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
      'Chúng tôi sẽ gửi cho bạn mã xác nhận đăng nhập qua số điện thoại bên dưới.',
      style: LightTextTheme.paragraph2.copyWith(color: LightColorTheme.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPhoneInput() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomPhoneInput(
      phoneController: _phoneController,
      countryCodes: _countryCodes,
      selectedCountry: _selectedCountry!,
      onCountryChanged: (CountryCode country) {
        setState(() {
          _selectedCountry = country;
        });
      },
      phoneError: _phoneError,
    );
  }

  Future<void> _handleContinue() async {
    // Reset previous errors
    setState(() {
      _phoneError = null;
    });

    // Validate phone number
    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Vui lòng nhập số điện thoại';
      });
      return;
    }

    // Basic phone number validation based on selected country
    // For most countries, phone numbers are between 7 and 15 digits
    if (_phoneController.text.length < 7 || _phoneController.text.length > 15) {
      setState(() {
        _phoneError = 'Số điện thoại không hợp lệ';
      });
      return;
    }

    // TODO: Implement phone verification logic
    // This would typically involve:
    // 1. Sending the phone number to your backend
    // 2. Backend triggers SMS verification
    // 3. Navigate to verification code input screen

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mã xác nhận đã được gửi đến số điện thoại của bạn'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate to verification code screen with animation
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VerificationScreen(
            phoneNumber: _phoneController.text,
            countryCode: _selectedCountry!.dialCode,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  Widget _buildContinueButton() {
    return CustomButton(
      hintText: 'Tiếp tục',
      isPrimary: true,
      onPressed: _handleContinue,
    );
  }
}
