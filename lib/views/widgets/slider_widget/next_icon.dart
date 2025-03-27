import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextIcon extends StatefulWidget {
  const NextIcon({super.key});

  @override
  State<NextIcon> createState() => _NextIconState();
}

void _skipIntro(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const DirectionScreen()),
  );
}

class _NextIconState extends State<NextIcon> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          onPressed: () => _skipIntro(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bỏ qua", style: LightTextTheme.headding3),
              const SizedBox(width: 8),
              SvgPicture.asset(
                "assets/icons/next.svg",
                width: 18,
                height: 10,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
