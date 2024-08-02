import 'dart:convert';

import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
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

  Future<void> removeFovorite(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorite') ?? [];

    favorites.removeWhere((articleJson) {
      Map<String, dynamic> articleMap = jsonDecode(articleJson);

      return articleMap['url'] == url;
    });

    await prefs.setStringList('favorite', favorites);
  }
}
