import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotFound extends StatefulWidget {
  final String? title;
  final String? message;
  const NotFound({super.key, this.title, this.message});

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImageTheme.notFoundIcon, height: 300, width: 300),
            const SizedBox(height: 20),
            Text(
              widget.title ?? 'Không tìm thấy nội dung',
              style: LightTextTheme.headding2.copyWith(
                color: LightColorTheme.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.message ?? 'Không có nội dung nào để hiển thị',
              style: LightTextTheme.paragraph2.copyWith(
                color: LightColorTheme.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: CustomButton(
                hintText: 'Quay lại trang trước',
                isPrimary: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
