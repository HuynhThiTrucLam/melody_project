import 'package:flutter/material.dart';

class Navigation {
  static void navigateTo(BuildContext context, Widget screen, bool isBack) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 0.1);
          var end = Offset.zero;
          var curve = Curves.easeOutCubic;

          if (isBack) {
            begin = Offset(-1.0, 0.0);
            end = Offset.zero;
            curve = Curves.easeInOut;
          }

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
