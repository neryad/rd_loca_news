import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/page/home_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

final prefs = SharedPreference();

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  prefs.darkMode ? ThemeMode.dark : ThemeMode.light,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  themeModeNotifier.value = prefs.darkMode ? ThemeMode.dark : ThemeMode.light;
  NewsService().initialize();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    themeModeNotifier.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: prefs.defaultColor,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: prefs.defaultColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeModeNotifier.value,
      home: const HomePage(),
    );
  }
}
