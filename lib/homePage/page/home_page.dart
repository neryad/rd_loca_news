import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rd_loca_news/favorites/pages/favorite_page.dart';
import 'package:rd_loca_news/homePage/page/tab_news_page.dart';
import 'package:rd_loca_news/settings/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const TabNewsPage(),
    const FavoritePage(),
    const SettingPages()
  ];

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Animate(
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
              ),
              label: 'Noticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Guardados',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
            )
          ],
        ),
      ).fade(duration: 500.ms).scale(delay: 500.ms),
    );
  }
}
