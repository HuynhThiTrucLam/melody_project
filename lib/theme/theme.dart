import 'package:MELODY/main.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: LightColorTheme.white,
    primaryColor: LightColorTheme.mainColor,
  );

  static ThemeData darkTheme = ThemeData();
}
