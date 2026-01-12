import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcomscreen.dart';
import 'theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const FinCiergeApp(),
    ),
  );
}

class FinCiergeApp extends StatelessWidget {
  const FinCiergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'FinCierge',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.grey[900],
            brightness: Brightness.dark,
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
