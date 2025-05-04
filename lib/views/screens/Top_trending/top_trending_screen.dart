import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/models/UI/fiter_tab.dart';
import 'package:MELODY/data/services/music_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Top_trending/trending_list.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopTrendingScreen extends StatefulWidget {
  const TopTrendingScreen({super.key});

  @override
  State<TopTrendingScreen> createState() => _TopTrendingScreenState();
}

class _TopTrendingScreenState extends State<TopTrendingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<MusicData>> topTrendingFuture;
  final MusicService _musicService = MusicService();

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
    topTrendingFuture = _musicService.getTopTrendingMusics();
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
          topTrendingFuture = _musicService.getTopTrendingMusics();
          break;
        case "vietnam":
          topTrendingFuture = _musicService.getTopTrendingMusicsByRegion(
            "vietnam",
          );
          break;
        case "usuk":
          topTrendingFuture = _musicService.getTopTrendingMusicsByRegion(
            "usuk",
          );
          break;
        case "kpop":
          topTrendingFuture = _musicService.getTopTrendingMusicsByRegion(
            "kpop",
          );
          break;
        default:
          topTrendingFuture = _musicService.getTopTrendingMusics();
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
              // IconButton(
              //   onPressed: () {
              //     print("Filter button pressed");
              //   },
              //   icon: SvgPicture.asset(
              //     ImageTheme.filterIcon,
              //     width: 14,
              //     height: 14,
              //     colorFilter: ColorFilter.mode(
              //       LightColorTheme.black,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              // ),
            ],
          ),

          SizedBox(height: 16),

          // Music List
          Expanded(
            child: TrendingList(
              topTrendingFuture: topTrendingFuture,
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
