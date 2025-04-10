import 'package:flutter/material.dart';
import 'package:MELODY/views/widgets/top_bar/top_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final bool isSearchBar;
  final VoidCallback? onBack;
  final Function(String)? onSearch;
  final VoidCallback? onNotification;

  const BaseLayout({
    required this.child,
    this.isSearchBar = false,
    this.onBack,
    this.onSearch,
    this.onNotification,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomTopBar(
            isSearchBar: isSearchBar,
            onBack: onBack ?? () => Navigator.pop(context),
            onSearch: onSearch ?? (String _) {},
            onNotification: onNotification ?? () {},
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
