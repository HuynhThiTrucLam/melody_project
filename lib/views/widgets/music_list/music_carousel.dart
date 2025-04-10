import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MusicCarousel extends StatefulWidget {
  @override
  _MusicCarouselState createState() => _MusicCarouselState();
}

class _MusicCarouselState extends State<MusicCarousel> {
  int activeIndex = 0;
  final controller = carousel.CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Đề xuất cho bạn", style: LightTextTheme.headding2),
              ],
            ),

            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: MusicDataList.musics.length ~/ 3,
              effect: WormEffect(
                dotWidth: 6,
                dotHeight: 6,
                dotColor: Color(0xFFE0D1D1), // Inactive dot color
                activeDotColor: LightColorTheme.black,
              ),
            ),
          ],
        ),

        SizedBox(height: 14),
        carousel.CarouselSlider.builder(
          carouselController: controller,
          itemCount: MusicDataList.musics.length,
          itemBuilder: (context, index, realIndex) {
            final item = MusicDataList.musics[index];
            return GestureDetector(
              onTap: () {
                // Handle item tap
                print("Tapped on ${item.name}");
              },
              child: MusicListItem(
                music: item,
                onTap: () {
                  // Handle item tap
                  print("Tapped on ${item.name}");
                },
              ),
            );
          },
          options: carousel.CarouselOptions(
            height: 250,
            initialPage: 1,
            enableInfiniteScroll: false,
            viewportFraction: 0.6,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => activeIndex = index);
            },
          ),
        ),
      ],
    );
  }

  // Widget buildMusicCard(Map<String, String> item) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 6),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       image: DecorationImage(
  //         image: NetworkImage(item['image']!),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         gradient: LinearGradient(
  //           colors: [Colors.black.withOpacity(0.6), Colors.transparent],
  //           begin: Alignment.bottomCenter,
  //           end: Alignment.topCenter,
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             decoration: BoxDecoration(
  //               color: Colors.green[600],
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             child: Text(
  //               item['views']!,
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             item['title']!,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16,
  //             ),
  //           ),
  //           Text(
  //             item['artist']!,
  //             style: TextStyle(color: Colors.white70, fontSize: 14),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
