import 'package:MELODY/views/widgets/slider_widget/slider_iem.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SliderList extends StatefulWidget {
  const SliderList({super.key});

  @override
  State<SliderList> createState() => _SliderListState();
}

class _SliderListState extends State<SliderList> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

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
      "text":
          "Khám phá bài hát mới, tạo playlist riêng, tận hưởng âm thanh tuyệt vời",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
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
          SizedBox(height: 40),
          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1, // Thin border for inactive dots
                  ),
                  color:
                      _currentPage == index ? Colors.black : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
