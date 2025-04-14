import 'package:MELODY/data/models/UI/tag_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';

class TopTrendingScreen extends StatefulWidget {
  const TopTrendingScreen({super.key});

  @override
  State<TopTrendingScreen> createState() => _TopTrendingScreenState();
}

class _TopTrendingScreenState extends State<TopTrendingScreen> {
  final List<TagData> types = TagTypeOfData.types;

  @override
  Widget build(BuildContext context) {
    final childContent = Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50, // Increased height to accommodate shadows
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: types.length,
                  clipBehavior: Clip.none, // Prevent clipping of shadows
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ), // Add padding for shadows
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 16,
                        right: index == types.length - 1 ? 0 : 0,
                      ),
                      child: TagButton(
                        label: types[index].name,
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
                              builder: (context) => const TopTrendingScreen(),
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
        ],
      ),
    );

    // Using BaseLayout with the updated parameters
    return BaseLayout(
      child: childContent,
      showBottomNav: false,
      showTopBar: true,
      isSearchBar: true,
      currentIndex:
          -1, // Use -1 or another value to indicate this is not part of the main navigation
      onNavigationTap: (_) {
        // Empty callback since navigation is disabled for this screen
        // You could also use Navigator.pop here to go back when tapped
      },
    );
  }
}
