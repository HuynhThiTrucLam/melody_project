import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/data/models/UI/fiter_tab.dart';
import 'package:MELODY/data/services/artist_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/screens/Producer_screen/producer_list.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';

class ProducerScreen extends StatefulWidget {
  const ProducerScreen({super.key});

  @override
  State<ProducerScreen> createState() => _ProducerScreenState();
}

class _ProducerScreenState extends State<ProducerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<ArtistData>> producersFuture;
  final ArtistService _artistService = ArtistService();

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
    _currentFilter = _filters[0]; // Initialize with first filter
    producersFuture = _artistService.getTopArtist(); // Initial data load

    _tabController.addListener(
      _handleTabChange,
    ); // Add listener for tab changes
  }

  // Handle tab changes and update the data based on the selected filter
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentFilter = _filters[_tabController.index];
        print(_currentFilter.code);

        switch (_currentFilter.code) {
          case "all":
            producersFuture = _artistService.getTopArtist();
            break;
          case "vietnam":
            producersFuture = _artistService.getArtistByRegion("vietnam");
            break;
          case "usuk":
            producersFuture = _artistService.getArtistByRegion("usuk");
            break;
          case "kpop":
            producersFuture = _artistService.getArtistByRegion("kpop");
            break;
          default:
            producersFuture = _artistService.getTopArtist();
        }
      });
    }
  }

  @override
  void dispose() {
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

          // Music List
          Expanded(
            child: ProducerList(
              artistFuture: producersFuture,
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
