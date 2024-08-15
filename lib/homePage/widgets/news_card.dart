import 'package:flutter/material.dart';
import 'package:rd_loca_news/details/models/details_model.dart';
import 'package:rd_loca_news/details/pages/details_page.dart';
import 'package:rd_loca_news/details/services/details_service.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewsCard extends StatefulWidget {
  final String newsPaper;

  const NewsCard({super.key, required this.newsPaper});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final SharedPreference _sharedPreference = SharedPreference();
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

        return LayoutBuilder(builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: isWideScreen
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      bool isFavorite = favorites[news[index].url] ?? false;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage(
                                width: double.infinity,
                                height: 225,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    './assets/epic-loading.gif'),
                                image: NetworkImage(
                                  news[index].img,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                news[index].title,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final Detail newDetail =
                                          await getDetailsOfNew(
                                              news[index].url);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsNewsPage(
                                            newDetails: newDetail,
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
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
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
                                    placeholder: const AssetImage(
                                        './assets/epic-loading.gif'),
                                    image: NetworkImage(
                                      news[index].img,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            onPressed: () async {
                                              final Detail newDetail =
                                                  await getDetailsOfNew(
                                                      news[index].url);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsNewsPage(
                                                    newDetails: newDetail,
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
        });
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
