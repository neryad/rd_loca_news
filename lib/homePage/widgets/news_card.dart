// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rd_loca_news/details/pages/details_page.dart';
import 'package:rd_loca_news/details/services/details_service.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/homePage/services/news_services.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';

class NewsCard extends StatefulWidget {
  final String newsPaper;

  const NewsCard({super.key, required this.newsPaper});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final SharedPreference _sharedPreference = SharedPreference();
  Map<String, bool> favorites = {};
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final savedFavorites = await _sharedPreference.getFavorites();
    setState(() {
      for (var fav in savedFavorites) {
        favorites[fav.url] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: NewsService().getNews(widget.newsPaper, forceRefresh: _refreshKey > 0),
      builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cargando noticias...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar noticias',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay noticias disponibles',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        final List<News> news = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isWideScreen = constraints.maxWidth > 800;

            return RefreshIndicator(
              onRefresh: () async {
                NewsService().clearCacheFor(widget.newsPaper);
                setState(() {
                  _refreshKey++;
                });
              },
              child: isWideScreen ? _buildGridView(news) : _buildListView(news),
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(List<News> news) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: news.length,
      itemBuilder: (context, index) {
        return _buildGridCard(news[index], index);
      },
    );
  }

  Widget _buildGridCard(News newsItem, int index) {
    final bool isFavorite = favorites[newsItem.url] ?? false;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(newsItem),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Hero(
              tag: 'news_img_${newsItem.url}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      imageUrl: newsItem.img,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    // Gradiente sobre la imagen
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        newsItem.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _navigateToDetails(newsItem),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Leer más',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        _buildIconButton(
                          icon: isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          onPressed: () => _toggleFavorite(newsItem),
                        ),
                        _buildIconButton(
                          icon: Icons.share_outlined,
                          onPressed: () => _shareNews(newsItem),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
          delay: (index * 50).ms,
        );
  }

  Widget _buildListView(List<News> news) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildListCard(news[index], index);
      },
    );
  }

  Widget _buildListCard(News newsItem, int index) {
    final bool isFavorite = favorites[newsItem.url] ?? false;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(newsItem),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              Hero(
                tag: 'news_img_${newsItem.url}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    imageUrl: newsItem.img,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _navigateToDetails(newsItem),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Leer más',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        _buildIconButton(
                          icon: isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          onPressed: () => _toggleFavorite(newsItem),
                        ),
                        _buildIconButton(
                          icon: Icons.share_outlined,
                          onPressed: () => _shareNews(newsItem),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).slideX(
          begin: -0.1,
          end: 0,
          duration: 300.ms,
          delay: (index * 50).ms,
        );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _navigateToDetails(News newsItem) async {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      content: const Row(
        children: [
          SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Cargando noticia...'),
        ],
      ),
      duration: const Duration(seconds: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    messenger.showSnackBar(snackBar);

    try {
      final service = DetailsService();
      final detail = await service.getDetailsOfNew(newsItem.url);

      messenger.hideCurrentSnackBar();

      if (!mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => DetailsNewsPage(newDetails: detail),
        ),
      );
    } on DetailsServiceException catch (e) {
      messenger.hideCurrentSnackBar();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.message),
          action: (e.type == DetailsErrorType.timeout ||
                  e.type == DetailsErrorType.noConnection)
              ? SnackBarAction(
                  label: 'Reintentar',
                  onPressed: () => _navigateToDetails(newsItem),
                )
              : null,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } on Exception catch (e) {
      messenger.hideCurrentSnackBar();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleFavorite(News newsItem) async {
    await _sharedPreference.saveFavorite(newsItem);
    setState(() {
      final currentState = favorites[newsItem.url] ?? false;
      favorites[newsItem.url] = !currentState;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favorites[newsItem.url] == true
              ? 'Noticia guardada'
              : 'Noticia eliminada de guardados',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _shareNews(News newsItem) {
    final messageToShare =
        '¡Últimas noticias: ${newsItem.title}! 📰\n📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${newsItem.url}\n\n¡Descarga NeryNews ya y no te pierdas ninguna noticia! 🚀📲';
    Share.share(messageToShare);
  }
}
