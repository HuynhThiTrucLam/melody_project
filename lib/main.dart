import 'package:MELODY/theme/theme.dart';
import 'package:MELODY/views/screens/Base_screen/base_screen.dart';
import 'package:MELODY/views/screens/Home_screen/home_screen.dart';
import 'package:MELODY/views/screens/Introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:MELODY/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: ThemeData(),
          // home: const Scaffold(body: IntroductionScreen()),
          home: BaseScreen(),
        );
      },
    );
  }
}
