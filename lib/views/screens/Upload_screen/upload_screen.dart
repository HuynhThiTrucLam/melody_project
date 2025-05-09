import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          SvgPicture.asset(ImageTheme.subcribeScreen, width: 350, height: 350),
          Text('Đăng ký thành viên', style: LightTextTheme.headding2),
          SizedBox(height: 8),
          Text(
            'Bạn cần đăng ký thành viên để tải lên bài hát \nHãy đăng ký để tải lên bài hát của bạn và chia sẻ với bạn bè của bạn.',
            style: LightTextTheme.paragraph2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          CustomButton(
            hintText: 'Đăng ký ngay',
            isPrimary: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
