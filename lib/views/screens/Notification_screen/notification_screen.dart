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
      child: notifiContent,
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
