import 'package:MELODY/routes/app_routes.dart';
import 'package:MELODY/views/screens/Base_screen/base_screen.dart';
import 'package:MELODY/views/screens/Music_player/music_player.dart';
import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Home_screen/top_trending_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
import 'package:MELODY/views/screens/Authentication/phone_sign_in_screen.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/screens/Search_screen/search_screen.dart';
// import 'package:MELODY/views/screens/Sign_in_screen/phone_sign_in_screen.dart';
// import 'package:MELODY/views/screens/Sign_in_screen/sign_in_sceen.dart';
import 'package:flutter/material.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.introduction:
        return MaterialPageRoute(builder: (_) => const IntroductionScreen());
      case AppRoutes.direction:
        return MaterialPageRoute(builder: (_) => const DirectionScreen());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case AppRoutes.phoneSignIn:
        return MaterialPageRoute(builder: (_) => const PhoneSignInScreen());
      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case AppRoutes.topTrending:
        return MaterialPageRoute(builder: (_) => TopTrendingScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => BaseScreen());
      case AppRoutes.songDetail:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MusicPlayer(musicId: arguments['songId']),
        );
      case AppRoutes.search_screen:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(initialQuery: "Hot trending"),
        );
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
