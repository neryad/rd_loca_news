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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList('favorite') ?? [];

    String articleJson = jsonEncode(article.toJson());

    favorites.add(articleJson);

    await prefs.setStringList('favorite', favorites);
  }

  Future<List<News>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorite') ?? [];

    return favorites.map((articleJson) {
      Map<String, dynamic> articleMap = jsonDecode(articleJson);
      return News.fromJson(articleMap);
    }).toList();
  }

  Future<void> removeFavorite(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorite') ?? [];

    favorites.removeWhere((articleJson) {
      Map<String, dynamic> articleMap = jsonDecode(articleJson);

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

  Color defaultColor = const Color.fromRGBO(0, 45, 98, 1);
}
