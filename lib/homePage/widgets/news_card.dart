import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    getNews();
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(
          'https://raw.githubusercontent.com/neryad/api-scrapping-news/master/assets/news.png',
        ),
      ),
      title: const Text('sígueme en el canal'),
      trailing: TextButton(onPressed: () {}, child: const Text('leer mas')),
    );
  }
}
