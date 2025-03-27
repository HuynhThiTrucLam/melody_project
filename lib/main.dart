import 'package:MELODY/theme/theme.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData(),
      home: const Scaffold(body: IntroductionScreen()),
    );
  }
}
