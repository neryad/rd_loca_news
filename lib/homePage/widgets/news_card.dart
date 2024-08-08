import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';

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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage('./assets/epic-loading.gif'),
                              image: NetworkImage(
                                news[index].img,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news[index].title,
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewPage(
                                              newsUrl: news[index].url,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Leer más'),
                                    ),
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
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final messageToShare =
                                            '¡Últimas noticias: ${news[index].title}! 📰\n 📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${news[index].url}\n\n¡Descarga NeryNews ya y no te pierdas ninguna noticia! 🚀📲';
                                        Share.share(messageToShare);
                                      },
                                      icon: const Icon(Icons.share),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
