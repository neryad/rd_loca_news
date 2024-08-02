import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/widgets/news_card.dart';

class TabNewsPage extends StatelessWidget {
  const TabNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nery News'),
          bottom: const TabBar(isScrollable: true, tabs: <Widget>[
            Tab(
              text: 'Diario Libre',
            ),
            Tab(
              text: 'El Nacional',
            ),
            Tab(
              text: 'Listin Diario',
            ),
            Tab(
              text: 'Remolacha',
            ),
            Tab(
              text: 'Nuevo diario',
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          NewsCard(
            newsPaper: 'diariolibre',
          ),
          NewsCard(
            newsPaper: 'nacional',
          ),
          NewsCard(
            newsPaper: 'listin',
          ),
          NewsCard(
            newsPaper: 'remolacha',
          ),
          NewsCard(
            newsPaper: 'nuevoDiario',
          ),
        ]),
      ),
    );
  }
}
