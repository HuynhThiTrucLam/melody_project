import 'package:MELODY/data/models/UI/album_data.dart';
import 'package:MELODY/data/models/UI/artist_data.dart';
import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/data/models/UI/tag_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Home_screen/top_trending_screen.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';
import 'package:MELODY/views/widgets/artist_list/artist_carousel.dart';
import 'package:MELODY/views/widgets/music_list/music_carousel.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  final List<TagData> tags = TagDataList.tags;
  HomeScreen({super.key});

  void onSearch(BuildContext context, String tag) {
    // Handle search action
    // For example, navigate to the search screen with the selected tag
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(initialQuery: tag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            //Heading
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Search bar
                      Row(
                        children: [
                          CustomSearchBar(
                            label: "Hot trending",
                            svgLeftIcon: ImageTheme.topTrendingIcon,
                            backgroundColor: Colors.white,
                            textColor: LightColorTheme.grey,
                            iconColor: LightColorTheme.grey,
                            borderRadius: BorderRadius.circular(50),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            width: 235,
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      //Hagtag buttons
                      Row(
                        children: [
                          TagButton(
                            label: "Bắc Bling",
                            backgroundColor: Colors.white,
                            textColor: LightColorTheme.grey,
                            textSize: 12,
                            borderRadius: BorderRadius.circular(50),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TagButton(
                            label: "Best of 2025",
                            textSize: 12,
                            backgroundColor: Colors.white,
                            textColor: LightColorTheme.grey,
                            borderRadius: BorderRadius.circular(50),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      //Tag buttons
                      SizedBox(
                        height: 50, // Increased height to accommodate shadows
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: tags.length,
                          clipBehavior:
                              Clip.none, // Prevent clipping of shadows
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ), // Add padding for shadows
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 0 : 16,
                                right: index == tags.length - 1 ? 0 : 0,
                              ),
                              child: TagButton(
                                label: tags[index].name,
                                backgroundColor:
                                    index == 0
                                        ? LightColorTheme.mainColor
                                        : LightColorTheme.white,
                                textColor:
                                    index == 0
                                        ? LightColorTheme.white
                                        : LightColorTheme.black,
                                borderRadius: BorderRadius.circular(50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                textSize: 14,
                                onClick: (tag) {
                                  // Navigate to search screen with the selected tag
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopTrendingScreen(),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated element
                Positioned(
                  right: 0,
                  top: -15, // Adjust to align with search bar
                  child: SvgPicture.asset(ImageTheme.chillMan),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Songs
            MusicCarousel(
              items: MusicDataList.musics,
              type: MediaType.song,
              title: "Đề xuất cho bạn",
            ),

            const SizedBox(height: 32),

            // Artists
            ArtistCarousel(artists: mockArtists, title: "Nghệ sĩ nổi bật"),

            const SizedBox(height: 32),

            // Albums
            MusicCarousel(
              items: AlbumDataList.albums,
              type: MediaType.album,
              title: "Album nổi bật",
            ),
          ],
        ),
      ),
    );
  }
}
