import 'package:MELODY/views/widgets/layout/base_layout.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifiContent = SafeArea(
      child: Column(
        children: [
          // Add your notification content here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Notification Content', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
    return BaseLayout(
      child: notifiContent, // No need for extra Container
      showBottomNav: false,
      showTopBar: true, // Hide the top bar
      isSearchBar: true,
    );
  }
}
