import 'package:MELODY/data/models/BE/membership_data.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Membership_screen/membership_item.dart';
import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';

class MemberShipScreen extends StatefulWidget {
  const MemberShipScreen({super.key});

  @override
  State<MemberShipScreen> createState() => _MemberShipScreenState();
}

class _MemberShipScreenState extends State<MemberShipScreen> {
  @override
  Widget build(BuildContext context) {
    final childContent = SingleChildScrollView(
      child: Column(
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Membership', style: LightTextTheme.headding1)],
            ),
          ),
          MembershipItem(
            membership: MembershipData(
              id: '1',
              name: 'Chill Guys',
              description: 'Mặc định khi tạo tài khoản',
              discount: 20,
              price: 32000,
              duration: 3,
              features: [
                'Tạo 1 playlist',
                'Nghe nhạc không quảng cáo',
                'Nghe nhạc offline',
                'Nghe nhạc chất lượng cao',
              ],
              createdAt: '2023-01-01',
              updatedAt: '2023-01-01',
            ),
          ),
        ],
      ),
    );

    return BaseLayout(
      child: childContent,
      showBottomNav: false,
      showTopBar: false,
      isSearchBar: false,
      isHeader: true,
      currentIndex: 1,
      onNavigationTap: (_) {},
    );
  }
}
