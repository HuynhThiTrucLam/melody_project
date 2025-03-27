import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.introduction:
        return MaterialPageRoute(builder: (_) => const IntroductionScreen());
      case AppRoutes.direction:
        return MaterialPageRoute(builder: (_) => const DirectionScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Không tìm thấy trang!')),
              ),
        );
    }
  }
}
