import 'package:MELODY/routes/app_routes.dart';
import 'package:MELODY/views/screens/Introduction_screen/direction_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
import 'package:MELODY/views/screens/Sign_in_screen/phone_sign_in_screen.dart';
import 'package:MELODY/views/screens/Sign_in_screen/sign_in_sceen.dart';
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
