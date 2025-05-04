import 'package:MELODY/data/models/BE/album_data.dart';
import 'package:MELODY/data/models/UI/fiter_tab.dart';
import 'package:MELODY/data/services/album_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Albums_screen.dart/albums_list.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:MELODY/views/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<AlbumData>> albumsFuture;
  final AlbumService _albumService = AlbumService();

  late Filter _currentFilter;

  // Define the list of filter options
  final List<Filter> _filters = [
    Filter(code: "all", name: "Tất cả"),
    Filter(code: "vietnam", name: "Việt Nam"),
    Filter(code: "usuk", name: "US/UK"),
    Filter(code: "kpop", name: "K-Pop"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);

    // Initialize _currentFilter with the first filter
    _currentFilter = _filters[0];

    // Add listener to tab controller
    _tabController.addListener(_handleTabChange);

    // Initial data load based on the filter
    albumsFuture = _albumService.getTopAlbums();
  }

  void _handleTabChange() {
    // Only handle the event when tab selection actually changes
    if (!_tabController.indexIsChanging) {
      return;
    }

    // Update the current filter based on selected tab
    setState(() {
      _currentFilter = _filters[_tabController.index];

      print(_currentFilter.code);
      // Update the future based on selected filter
      switch (_currentFilter.code) {
        case "all":
          albumsFuture = _albumService.getTopAlbums();
          break;
        case "vietnam":
          albumsFuture = _albumService.getTopAlbumsByRegion("vietnam");
          break;
        case "usuk":
          albumsFuture = _albumService.getTopAlbumsByRegion("usuk");
          break;
        case "kpop":
          albumsFuture = _albumService.getTopAlbumsByRegion("kpop");
          break;
        default:
          albumsFuture = _albumService.getTopAlbums();
      }
    });
  }

  @override
  void dispose() {
    // Remove listener before disposing
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childContent = Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          // Tab bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: LightColorTheme.mainColor,
                labelColor: LightColorTheme.black,
                unselectedLabelColor: Colors.grey,
                tabAlignment: TabAlignment.start,
                tabs: _filters.map((filter) => Tab(text: filter.name)).toList(),
                dividerHeight: 0,
                labelPadding: EdgeInsets.only(left: 0, right: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSearchBar(
                label: "Hot trending",
                svgLeftIcon: ImageTheme.searchIcon,
                iconSize: 24,
                backgroundColor: Colors.white,
                textColor: LightColorTheme.black,

                iconColor: LightColorTheme.black,
                borderRadius: BorderRadius.circular(4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  onPressed: () => {},
                  icon: SvgPicture.asset(
                    ImageTheme.filterIcon,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Albums List
          Expanded(
            child: AlbumsList(
              albumsFuture: albumsFuture,
            ), // Pass the Future here
          ),
        ],
      ),
    );

    return BaseLayout(
      child: childContent,
      showBottomNav: false,
      showTopBar: true,
      isSearchBar: false,
      currentIndex: -1,
      onNavigationTap: (_) {},
    );
  }
}
