import 'package:MELODY/core/models/country_code.dart';
import 'package:MELODY/core/services/country_code_service.dart';
import 'package:MELODY/core/utils/navigation.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/verification_screen.dart';
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
      _phoneError = null;
      _isLoading = true;
    });

    // Validate phone number
    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Vui lòng nhập số điện thoại';
        _isLoading = false;
      });
      return;
    }

    // Basic phone number validation based on selected country
    // For most countries, phone numbers are between 7 and 15 digits
    if (_phoneController.text.length < 7 || _phoneController.text.length > 15) {
      setState(() {
        _phoneError = 'Số điện thoại không hợp lệ';
        _isLoading = false;
      });
      return;
    }

    try {
      // TODO: Implement phone verification logic
      // This would typically involve:
      // 1. Sending the phone number to your backend
      // 2. Backend triggers SMS verification
      // 3. Navigate to verification code input screen

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mã xác nhận đã được gửi đến số điện thoại của bạn',
            style: TextStyle(color: LightColorTheme.mainColor),
          ),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to verification code screen with animation
      setState(() {
        _isLoading = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigation.navigateTo(
          context,
          VerificationScreen(
            phoneNumber: _phoneController.text,
            countryCode: _selectedCountry!.dialCode,
          ),
          true,
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

  Widget _buildContinueButton() {
    return CustomButton(
      hintText: 'Tiếp tục',
      isPrimary: true,
      onPressed: _handleContinue,
    );
  }
}
