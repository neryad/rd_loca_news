import 'dart:convert';
import 'dart:ui';

import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final SharedPreference _instance = SharedPreference._internal();

  factory SharedPreference() {
    return _instance;
  }

  SharedPreference._internal();

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveFavorite(News article) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> favorites = prefs.getStringList('favorite') ?? [];

    final String articleJson = jsonEncode(article.toJson());

    favorites.add(articleJson);

    await prefs.setStringList('favorite', favorites);
  }

  Future<List<News>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorite') ?? [];

    return favorites.map((articleJson) {
      final Map<String, dynamic> articleMap = jsonDecode(articleJson) as Map<String, dynamic>;
      return News.fromJson(articleMap);
    }).toList();
  }

  Future<void> removeFavorite(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorite') ?? [];

    favorites.removeWhere((articleJson) {
      final Map<String, dynamic> articleMap = jsonDecode(articleJson) as Map<String, dynamic>;

      return articleMap['url'] == url;
    });

    await prefs.setStringList('favorite', favorites);
  }

  bool get darkMode {
    return _prefs.getBool('isDarkMode') ?? false;
  }

  set darkMode(bool value) {
    _prefs.setBool('isDarkMode', value);
  }

  Color get defaultColor {
    final value = _prefs.getInt('defaultColor');
    if (value != null) return Color(value);
    return const Color.fromRGBO(0, 45, 98, 1);
  }

  set defaultColor(Color color) {
    _prefs.setInt('defaultColor', color.toARGB32());
  }
}
