import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/page/web_view_page.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    SharedPreference sharedPreference = SharedPreference();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias Favoritas'),
      ),
      body: FutureBuilder(
          future: sharedPreference.getFavorites(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<News> news = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
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
                            placeholder:
                                const AssetImage('./assets/epic-loading.gif'),
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
                                                  builder: (context) =>
                                                      WebViewPage(
                                                        newsUrl:
                                                            news[index].url,
                                                      )));
                                        },
                                        child: const Text('Leer mas')),
                                    IconButton(
                                        onPressed: () async {
                                          await sharedPreference
                                              .removeFavorite(news[index].url);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.bookmark,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          final messageToShare =
                                              '¡Últimas noticias: ${news[index].title}! 📰\n 📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${news[index].url}\n\n¡Descarga Nery News ya y no te pierdas ninguna noticia! 🚀📲';

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
                  }),
            );
          }),
    );
  }
}
