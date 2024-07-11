import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:share_plus/share_plus.dart';
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        // width: 150,
                        // height: 150,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          news[index].img,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 250,
                                child: Text(
                                  news[index].title,
                                )),
                            SizedBox(
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewPage(
                                                      newsUrl: news[index].url,
                                                    )));
                                      },
                                      child: const Text('Leer mas')),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.bookmark)),
                                  IconButton(
                                      onPressed: () {
                                        final messageToShare =
                                            '📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${news[index].url} \nNoticias frescas y análisis interesantes, ¡directo en tu bolsillo! 🌟';
                                        Share.share(messageToShare);
                                        // Share.shareUri(Uri.parse(
                                        //     'mira esta notiocia:$news[index].url'));
                                      },
                                      icon: const Icon(Icons.share))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                //  return newsTile(news[index], context);
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
