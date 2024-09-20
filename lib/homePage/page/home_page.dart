import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rd_loca_news/favorites/pages/favorite_page.dart';
import 'package:rd_loca_news/homePage/page/tab_news_page.dart';
import 'package:rd_loca_news/settings/pages/setting_page.dart';
import 'package:rd_loca_news/shared/ad_helper.dart';

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
  BannerAd? _bannerAd;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        }, onAdFailedToLoad: (ad, err) {
          log('Falo en cargar el banner add: ${err.message}');
          ad.dispose();
        })).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _pages[_currentIndex]),
          if (_bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
      bottomNavigationBar: Animate(
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
              ),
              label: 'Noticias',
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
