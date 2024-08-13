import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/page/home_page.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

final prefs = SharedPreference();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static void stateSet(BuildContext context) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: prefs.defaultColor,
              brightness: prefs.darkMode ? Brightness.dark : Brightness.light)),
      home: const HomePage(),
    );
  }
}
