import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'global_data.dart';
import 'routes.dart';

// TODO: make new icon
// TODO: make util lighter
// FIXME: when a pdf widget is bigger than one page, it errors with "cannot be larger than 20 pages"
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // getIt setup
  GetIt.I.registerSingleton<GlobalData>(GlobalData());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue.shade900,
        brightness: Brightness.dark,
      ),
    ).copyWith(
      scaffoldBackgroundColor: Colors.black,
    );
    // darkTheme = darkTheme.copyWith(scaffoldBackgroundColor: Colors.black);
    // darkTheme = darkTheme.copyWith(tabBarTheme:TabBarTheme());
    ThemeData lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue.shade500,
        brightness: Brightness.light,
      ),
    ).copyWith(
      canvasColor: Colors.lightBlue.shade50,
      cardColor: Colors.lightBlue.shade50,
    );

    return MaterialApp(
      title: 'PESA',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const SplashScreen(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/survey_selection": (context) => const SurveySelectionScreen(),
        "/survey": (context) => const SurveyScreen(),
      },
      // Routes with Paramaters
      onGenerateRoute: (settings) {
        if (settings.name == "/explanation") {
          // give arguments as (surveyNumber)
          final String mdKeyArg = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ExplanationScreen(mdkey: mdKeyArg),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const SplashScreen(),
          );
        }
      },
    );
  }
}
