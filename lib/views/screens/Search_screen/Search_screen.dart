import 'package:MELODY/data/models/UI/tag_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
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
  late TextEditingController searchController;
  late String searchQuery;
  final FocusNode searchFocusNode = FocusNode();
  final List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchQuery = '';
    searchController = TextEditingController(text: searchQuery);

    // Auto-focus when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });

    performSearch(searchQuery);
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      searchResults.clear();

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
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showBottomNav: false,
      showTopBar: true,
      isSearchBar: true,
      isTypingEnabled: true,
      searchController: searchController,
      onSearch: performSearch,
      onBack: () => Navigator.pop(context),
      onNotification: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        );
      },
      currentIndex: -1,
      onNavigationTap: (_) {},
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Hot trending tags
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
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: TagDataList.tags.length,
                        itemBuilder: (context, index) {
                          final tag = TagDataList.tags[index].name;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TagButton(
                              label: tag,
                              backgroundColor: Colors.white,
                              textColor: LightColorTheme.grey,
                              textSize: 12,
                              borderRadius: BorderRadius.circular(50),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              // onClick: () {
                              //   searchController.text = tag;
                              //   performSearch(tag);
                              // },
                            ),
                          );
                        },
                      ),
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
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        // TODO: Navigate to the result
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
      ),
    );
  }
}
