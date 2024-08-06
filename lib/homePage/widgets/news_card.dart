import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsCard extends StatefulWidget {
  final String newsPaper;
  // final webviewController = WebViewController();
  NewsCard({super.key, required this.newsPaper});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  SharedPreference _sharedPreference = SharedPreference();
  Map<String, bool> favorites = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(widget.newsPaper),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<News> news = snapshot.data;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                bool isFavorite = favorites[news[index].url] ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                        width: 150,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('./assets/epic-loading.gif'),
                        image: NetworkImage(
                          news[index].img,
                          // width: 150,
                          // height: 120,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                news[index].title,
                                style: const TextStyle(
                                    overflow: TextOverflow.clip,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewPage(
                                                    newsUrl: news[index].url,
                                                  )));
                                    },
                                    child: const Text('Leer mas')),
                                IconButton(
                                    onPressed: () async {
                                      await _sharedPreference
                                          .saveFavorite(news[index]);

                                      setState(() {
                                        favorites[news[index].url] =
                                            !isFavorite;
                                      });
                                    },
                                    icon: Icon(
                                        isFavorite
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isFavorite
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey)),
                                IconButton(
                                    onPressed: () {
                                      final messageToShare =
                                          '¡Últimas noticias: ${news[index].title}! 📰\n 📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${news[index].url}\n\n¡Descarga NeryNews ya y no te pierdas ninguna noticia! 🚀📲';

                                      Share.share(
                                        messageToShare,
                                      );
                                    },
                                    icon: const Icon(Icons.share))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
