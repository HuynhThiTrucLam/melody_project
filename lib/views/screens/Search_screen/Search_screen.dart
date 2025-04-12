import 'package:MELODY/data/models/UI/tag_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({Key? key, required this.initialQuery}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchQuery;
  final List<String> searchResults = [];
  final FocusNode searchFocusNode = FocusNode();
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    searchController = TextEditingController(text: searchQuery);

    // Auto-focus the search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  void performSearch(String query) {
    setState(() {
      searchResults.clear();
      searchQuery = query;
      // Mock results for demonstration
      if (query.isNotEmpty) {
        searchResults.addAll([
          'Result 1 for "$query"',
          'Result 2 for "$query"',
          'Result 3 for "$query"',
          'Result 4 for "$query"',
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The content of your search screen
    final searchContent = SafeArea(
      child: Column(
        children: [
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 16.0,
              right: 16.0,
              bottom: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                GoBackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(width: 14), // Space between back button and search bar

                Expanded(
                  child: Hero(
                    tag: 'searchBarHero',
                    child: Material(
                      color: Colors.transparent,
                      child: CustomSearchBar(
                        label: searchQuery,
                        // svgLeftIcon: ImageTheme.topTrendingIcon,
                        isInSearchScreen: true,
                        controller: searchController,
                        focusNode: searchFocusNode,
                        onChanged: performSearch,
                        backgroundColor: Colors.white,
                        textColor: LightColorTheme.grey,
                        iconColor: LightColorTheme.grey,
                        borderRadius: BorderRadius.circular(50),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8), // Space between back button and search bar

                NotificationButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  hasNewNotification: true,
                ),
              ],
            ),
          ),

          // Animated content container
          Expanded(
            child: SafeArea(
              minimum: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  //Hot trending
                  Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(ImageTheme.topTrendingIcon),
                          const SizedBox(width: 8),
                          Text(
                            'Tìm kiếm nhiều nhất',
                            style: LightTextTheme.paragraph2,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      //Hagtag buttons
                      SizedBox(
                        height: 40, // Set a fixed height for the list
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: TagDataList.tags.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: 8,
                                left: index == 0 ? 0 : 0,
                              ),
                              child: TagButton(
                                label: TagDataList.tags[index].name,
                                backgroundColor: Colors.white,
                                textColor: LightColorTheme.grey,
                                textSize: 12,
                                borderRadius: BorderRadius.circular(50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                // onClick: () {
                                //   // Handle tag button click
                                //   setState(() {
                                //     searchQuery = TagDataList.tags[index].name;
                                //     searchController.text = searchQuery;
                                //     performSearch(searchQuery);
                                //   });
                                // },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search results
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          searchResults.isEmpty
                              ? const Center(
                                key: ValueKey('empty'),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Tìm kiếm nội dung bạn thích',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: LightColorTheme.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        'Tìm kiếm nghệ sĩ, bài hát, albums và nhiều nội dung khác',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: LightColorTheme.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : ListView.builder(
                                key: const ValueKey('results'),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(searchResults[index]),
                                    leading: const Icon(Icons.music_note),
                                    onTap: () {
                                      // Handle result selection
                                    },
                                  );
                                },
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Wrap your content with BaseLayout
    return BaseLayout(
      child: searchContent, // No need for extra Container
      showBottomNav: false,
      showTopBar: false, // Hide the top bar
    );
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }
}
