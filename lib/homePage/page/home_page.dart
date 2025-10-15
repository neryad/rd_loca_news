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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Widget> _pages = [
    const TabNewsPage(),
    const FavoritePage(),
    const SettingPages()
  ];

  int _currentIndex = 0;
  BannerAd? _bannerAd;
  bool _isAdLoading = true;
  late AnimationController _fadeController;

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      // Feedback háptico sutil (opcional)
      // HapticFeedback.lightImpact();
    }
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _loadBannerAd();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isAdLoading = false;
          });
          _fadeController.forward();
        },
        onAdFailedToLoad: (ad, err) {
          log('Fallo al cargar el banner ad: ${err.message}');
          setState(() {
            _isAdLoading = false;
          });
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Contenido principal con animación de transición
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<int>(_currentIndex),
                child: _pages[_currentIndex],
              ),
            ),
          ),

          // Banner Ad con animación y mejor manejo de estados
          if (_isAdLoading)
            SizedBox(
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            )
          else if (_bannerAd != null)
            FadeTransition(
              opacity: _fadeController,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),

      // BottomNavigationBar mejorado
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.newspaper_outlined, 0),
              activeIcon: _buildNavIcon(Icons.newspaper, 0, isActive: true),
              label: 'Noticias',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.bookmark_outline, 1),
              activeIcon: _buildNavIcon(Icons.bookmark, 1, isActive: true),
              label: 'Guardados',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.settings_outlined, 2),
              activeIcon: _buildNavIcon(Icons.settings, 2, isActive: true),
              label: 'Ajustes',
            ),
          ],
        ).animate().fadeIn(duration: 500.ms).slideY(
              begin: 0.3,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool isActive = false}) {
    final isSelected = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: isActive ? 26 : 24,
      ),
    );
  }
}
