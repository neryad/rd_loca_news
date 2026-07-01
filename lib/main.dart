import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rd_loca_news/homePage/page/home_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

final prefs = SharedPreference();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar servicios en paralelo para mejor performance
    await Future.wait([
      // MobileAds.instance.initialize(),
      prefs.initPrefs(),
    ]);

    log('✅ Servicios inicializados correctamente');
  } on Exception catch (e) {
    log('❌ Error al inicializar servicios: $e');
  }

  // Inicializar servicios de API (singleton pattern)
  NewsService().initialize();
  // DetailsService().initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static void stateSet(BuildContext context) {
    final _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
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
          brightness: prefs.darkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const HomePage(),
    );
  }
}
