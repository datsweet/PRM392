// Lab 4 - Flutter UI Fundamentals
import 'package:flutter/material.dart';
import 'package:untitled/ui/screens/lab4/lab4_home.dart';

// Notifier toàn cục để chuyển đổi ThemeMode giữa Light và Dark cho toàn app (Exercise 4).
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: "Lab 4 - Flutter UI Fundamentals",
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // Custom ThemeData cho Light Mode
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              shape: CircleBorder(),
            ),
          ),
          // Custom ThemeData cho Dark Mode
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              shape: CircleBorder(),
            ),
          ),
          home: const Lab4Home(),
        );
      },
    );
  }
}

