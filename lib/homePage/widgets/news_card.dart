import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';

class NewsCard extends StatelessWidget {
  final String newsPaper;
  const NewsCard({super.key, required this.newsPaper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(newsPaper),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<News> news = snapshot.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return newstile(news[index]);
              }),
        );
      },
    );
  }

  ListTile newstile(News news) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          news.img,
        ),
      ),
      title: Text(news.title),
      trailing: TextButton(onPressed: () {}, child: const Text('leer mas')),
    );
  }
}
