import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MusicCarousel extends StatefulWidget {
  final List<dynamic> items; // MusicData or AlbumData
  final MediaType type;
  final String title;
  final int? headingSize;

  const MusicCarousel({
    Key? key,
    required this.items,
    required this.type,
    required this.title,
    this.headingSize,
  }) : super(key: key);

  @override
  _MusicCarouselState createState() => _MusicCarouselState();
}

class _MusicCarouselState extends State<MusicCarousel> {
  int activeIndex = 1;
  final controller = carousel.CarouselSliderController();
  int get dotCount => (widget.items.length / 3).ceil(); // 1 dot per 3 items

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title if have heading size
            if (widget.headingSize != null)
              Text(
                widget.title,
                style: LightTextTheme.headding2.copyWith(
                  fontSize: widget.headingSize!.toDouble(),
                ),
              )
            else
              Text(widget.title, style: LightTextTheme.headding2),
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: dotCount,
              onDotClicked: (dotIndex) {
                controller.animateToPage(dotIndex * 3); // Jump 3 items forward
              },
              effect: WormEffect(
                dotWidth: 6,
                dotHeight: 6,
                dotColor: const Color(0xFFE0D1D1),
                activeDotColor: LightColorTheme.black,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Carousel
        carousel.CarouselSlider.builder(
          carouselController: controller,
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) {
            final item = widget.items[index];
            return MusicListItem(
              item: item,
              type: widget.type,
              onTap: () {
                // You can pass a callback if needed
                print(
                  "Tapped on ${widget.type == MediaType.song ? item.name : item.title}",
                );
              },
            );
          },
          options: carousel.CarouselOptions(
            height: 250,
            initialPage: activeIndex,
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
}
