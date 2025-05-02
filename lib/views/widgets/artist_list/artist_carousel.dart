import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Artist_screen/Artist_profile.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'artist_item.dart';

class ArtistCarousel extends StatefulWidget {
  final List<ArtistData> artists;
  final String title;

  const ArtistCarousel({Key? key, required this.artists, required this.title})
    : super(key: key);

  @override
  _ArtistCarouselState createState() => _ArtistCarouselState();
}

class _ArtistCarouselState extends State<ArtistCarousel> {
  int activeIndex = 0;
  final controller = carousel.CarouselSliderController();

  int get dotCount => (widget.artists.length / 2).ceil(); // 2 item / page

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: LightTextTheme.headding2),
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: dotCount,
              onDotClicked: (dotIndex) {
                controller.animateToPage(dotIndex * 2);
              },
              effect: WormEffect(
                dotWidth: 6,
                dotHeight: 6,
                dotColor: const Color(0xFFE0D1D1),
                activeDotColor: Colors.black,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          clipBehavior: Clip.none, // Important: Don't clip overflow
          width: double.infinity,
          child: carousel.CarouselSlider.builder(
            carouselController: controller,
            itemCount: widget.artists.length,
            itemBuilder: (context, index, realIndex) {
              final artist = widget.artists[index];
              return Container(
                // Fix the corrupted margin declaration
                margin: const EdgeInsets.only(right: 16),
                clipBehavior: Clip.none, // Ensure this container doesn't clip
                child: GestureDetector(
                  onTap: () {
                    // Handle artist item tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ArtistProfile(artistId: artist.id),
                      ),
                    );
                  },
                  child: ArtistItem(
                    itemType: ItemType.artist,
                    name: artist.name,
                    subText: artist.followers.toString(),
                    avatarUrl: artist.avatarUrl,
                    isVerified: artist.isVerified,
                  ),
                ),
              );
            },
            options: carousel.CarouselOptions(
              padEnds: false, // Don't add padding at edges
              height: 90, // Adjust height as needed
              initialPage: activeIndex,
              enableInfiniteScroll: false,
              viewportFraction: 0.7, // Slightly less than 0.5 to create gap
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() => activeIndex = (index / 2).floor());
              },
            ),
          ),
        ),
      ],
    );
  }
}
