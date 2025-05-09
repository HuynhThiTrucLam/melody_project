import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/sign_up_sceen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DirectionScreen extends StatelessWidget {
  const DirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _handleClickOnAlreadyHaveAccount(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }

    void _handleClickOnSignUp(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    SvgPicture.asset(ImageTheme.logoCircle, width: 80),
                    const SizedBox(height: 32),

                    // Tiêu đề chính
                    Text(
                      "Bùng nổ âm nhạc\nKết nối đam mê",
                      textAlign: TextAlign.center,
                      style: LightTextTheme.bold.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: 16),

                    // Đoạn mô tả
                    Text(
                      "Với kho nhạc khổng lồ, đa dạng thể loại từ những bản hit quốc tế đến những giai điệu quen thuộc. "
                      "Chúng tôi hứa hẹn sẽ mang đến cho bạn những giây phút thư giãn và thăng hoa cùng âm nhạc.",
                      textAlign: TextAlign.center,
                      style: LightTextTheme.paragraph2.copyWith(
                        fontSize: 16,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // Logo/Icon
              const SizedBox(height: 32),

              CustomButton(
                hintText: "Tôi đã có tài khoản",
                isPrimary: true,
                onPressed: () => _handleClickOnAlreadyHaveAccount(context),
              ),
              const SizedBox(height: 16),

              CustomButton(
                hintText: "Đăng ký tài khoản miễn phí",
                isPrimary: false,
                onPressed: () => _handleClickOnSignUp(context),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
