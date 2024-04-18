import 'package:dio/dio.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';

Future<List<News>> getNews(String newsPaper) async {
  final List<News> news;

  final dio = Dio();

  //TODO: Poner dinamuico la url
  var url = 'https://api-scrapping-news.onrender.com/api/$newsPaper';

  final response = await dio.get(url);

  final List jsonResponse = response.data["data"];
  news = jsonResponse.map((result) => News.fromJson((result))).toList();
  //print(news[0].title);
  return news;
}
