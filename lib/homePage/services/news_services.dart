import 'package:dio/dio.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';

Future<List<News>> getNews() async {
  final List<News> news;

  final dio = Dio();

  //TODO: Poner dinamuico la url
  const url = 'https://api-scrapping-news.onrender.com/api/remolacha';

  final response = await dio.get(url);

  final List jsonResponse = response.data["data"];
  news = jsonResponse.map((result) => News.fromJson((result))).toList();
  print(news[0].title);
  return news;
}
