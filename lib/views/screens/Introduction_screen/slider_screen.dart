import 'package:MELODY/views/widgets/slider_widget/next_icon.dart';
import 'package:MELODY/views/widgets/slider_widget/slider_iem.dart';
import 'package:flutter/material.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/icons/slider1.svg",
      "text": "Thưởng thức âm nhạc mọi lúc, mọi nơi với trải nghiệm tuyệt vời",
    },
    {
      "image": "assets/icons/slider2.svg",
      "text": "Kho nhạc phong phú, chất lượng cao, giai điệu chạm cảm xúc",
    },
    {
      "image": "assets/icons/slider3.svg",
      "text": "Khám phá bài hát mới, tạo playlist riêng, tận hưởng âm thanh",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            NextIcon(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SliderItem(
                    imagePath: slides[index]["image"]!,
                    text: slides[index]["text"]!,
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1, // Thin border for inactive dots
                    ),
                    color:
                        _currentPage == index
                            ? Colors.black
                            : Colors.transparent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
