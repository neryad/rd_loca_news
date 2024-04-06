import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/widgets/news_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('local news'),
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
        body: const TabBarView(children: <Widget>[
          NewsCard(),
          Text('data2'),
          Text('data3'),
          Text('data4'),
          Text('data5')
        ]),
      ),
    );
  }
}
