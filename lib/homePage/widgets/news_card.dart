import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsCard extends StatelessWidget {
  final String newsPaper;
  final webviewController = WebViewController();
  NewsCard({super.key, required this.newsPaper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(newsPaper),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<News> news = snapshot.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return newsTile(news[index], context);
              }),
        );
      },
    );
  }

  ListTile newsTile(News news, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          news.img,
        ),
      ),
      title: Text(news.title),
      trailing: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewPage(
                          newsUrl: news.url,
                        )));
            //  WebViewPage();
            // webviewController.loadRequest(Uri.parse(news.url));
          },
          child: const Text('leer mas')),
    );
  }
}
