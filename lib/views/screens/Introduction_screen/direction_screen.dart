import 'package:MELODY/views/screens/Sign_in_screen/sign_in_sceen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

void _handleClickOnAlreadyHaveAccount(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SignInScreen()),
  );
}

class DirectionScreen extends StatelessWidget {
  const DirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: LightColorTheme.mainColor,
                      ),
                      child: Icon(
                        Icons.music_note,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 42),

                    // Tiêu đề chính
                    Text(
                      "Bùng nổ âm nhạc\nKết nối đam mê",
                      textAlign: TextAlign.center,
                      style: LightTextTheme.bold.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: 32),

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
                onPressed: () => {},
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
