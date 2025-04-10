import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    // Auto-focus the search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      // Mock results for demonstration
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Animated content container
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    searchResults.isEmpty
                        ? const Center(
                          child: Text('Enter search terms to find music'),
                        )
                        : ListView.builder(
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
    );
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }
}
