// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:rd_loca_news/details/models/details_model.dart';
// import 'package:rd_loca_news/details/pages/details_page.dart';
// import 'package:rd_loca_news/details/services/details_service.dart';
// import 'package:rd_loca_news/homePage/models/news_model.dart';
// import 'package:rd_loca_news/shared/shared_preference.dart';
// import 'package:share_plus/share_plus.dart';

// class FavoritePage extends StatefulWidget {
//   const FavoritePage({super.key});

//   @override
//   State<FavoritePage> createState() => _FavoritePageState();
// }

// class _FavoritePageState extends State<FavoritePage> {
//   @override
//   Widget build(BuildContext context) {
//     SharedPreference sharedPreference = SharedPreference();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Noticias Favoritas'),
//       ),
//       body: FutureBuilder(
//           future: sharedPreference.getFavorites(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             final List<News> news = snapshot.data;

//             return Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: ListView.builder(
//                   itemCount: news.length,
//                   itemBuilder: (context, index) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10.0),
//                           child: FadeInImage(
//                             width: 150,
//                             height: 120,
//                             fit: BoxFit.cover,
//                             placeholder:
//                                 const AssetImage('./assets/epic-loading.gif'),
//                             image: NetworkImage(
//                               news[index].img,
//                               // width: 150,
//                               // height: 120,
//                               // fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             // mainAxisAlignment: MainAxisAlignment.center,
//                             // crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                   width: MediaQuery.of(context).size.width / 2,
//                                   child: Text(
//                                     news[index].title,
//                                     style: const TextStyle(
//                                         overflow: TextOverflow.clip,
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold),
//                                   )),
//                               SizedBox(
//                                 child: Row(
//                                   children: [
//                                     TextButton(
//                                         onPressed: () async {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible:
//                                                 false, // Para prevenir que el diálogo se cierre al tocar fuera de él
//                                             builder: (BuildContext context) {
//                                               return const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               );
//                                             },
//                                           );

//                                           final Detail newDetail =
//                                               await getDetailsOfNew(
//                                                   news[index].url);
//                                           Navigator.pop(context);
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   DetailsNewsPage(
//                                                 newDetails: newDetail,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: const Text('Leer mas')),
//                                     IconButton(
//                                         onPressed: () async {
//                                           await sharedPreference
//                                               .removeFavorite(news[index].url);
//                                           setState(() {});
//                                         },
//                                         icon: const Icon(
//                                           Icons.bookmark,
//                                         )),
//                                     IconButton(
//                                         onPressed: () {
//                                           final messageToShare =
//                                               '¡Últimas noticias: ${news[index].title}! 📰\n 📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${news[index].url}\n\n¡Descarga Nery News ya y no te pierdas ninguna noticia! 🚀📲';

//                                           Share.share(
//                                             messageToShare,
//                                           );
//                                         },
//                                         icon: const Icon(Icons.share))
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//             );
//           }),
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rd_loca_news/details/models/details_model.dart';
import 'package:rd_loca_news/details/pages/details_page.dart';
import 'package:rd_loca_news/details/services/details_service.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:share_plus/share_plus.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final SharedPreference _sharedPreference = SharedPreference();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.bookmark,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Guardados'),
          ],
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<News>>(
        future: _sharedPreference.getFavorites(),
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando guardados...',
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
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar guardados',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
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

          final List<News> news = snapshot.data ?? [];

          if (news.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: news.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildFavoriteCard(news[index], index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes noticias guardadas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Guarda tus noticias favoritas para leerlas más tarde',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Usa el ícono',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.bookmark_border,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'para guardar',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).scale(delay: 200.ms),
    );
  }

  Widget _buildFavoriteCard(News newsItem, int index) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(newsItem.url),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(height: 4),
            Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 12),
                  Text('¿Eliminar noticia?'),
                ],
              ),
              content: const Text(
                '¿Estás seguro que deseas eliminar esta noticia de tus guardados?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await _removeFavorite(newsItem);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
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
                  tag: 'favorite_${newsItem.url}_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('./assets/epic-loading.gif'),
                      image: NetworkImage(newsItem.img),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 110,
                          height: 110,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.broken_image,
                            size: 32,
                            color: Colors.grey[500],
                          ),
                        );
                      },
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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () => _navigateToDetails(newsItem),
                              icon: const Icon(Icons.read_more, size: 16),
                              label: const Text(
                                'Leer más',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          _buildIconButton(
                            icon: Icons.bookmark,
                            color: theme.colorScheme.primary,
                            onPressed: () => _showRemoveDialog(newsItem),
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
          ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      color: color,
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cargando noticia...',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final Detail newDetail = await getDetailsOfNew(newsItem.url);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsNewsPage(
            newDetails: newDetail,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al cargar los detalles'),
          action: SnackBarAction(
            label: 'Reintentar',
            onPressed: () => _navigateToDetails(newsItem),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _showRemoveDialog(News newsItem) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.bookmark_remove, color: Colors.orange),
              SizedBox(width: 12),
              Text('¿Eliminar noticia?'),
            ],
          ),
          content: const Text(
            '¿Deseas eliminar esta noticia de tus guardados?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _removeFavorite(newsItem);
    }
  }

  Future<void> _removeFavorite(News newsItem) async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _sharedPreference.removeFavorite(newsItem.url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Noticia eliminada'),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al eliminar la noticia'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _shareNews(News newsItem) {
    final messageToShare =
        '¡Últimas noticias: ${newsItem.title}! 📰\n📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${newsItem.url}\n\n¡Descarga Nery News ya y no te pierdas ninguna noticia! 🚀📲';
    Share.share(messageToShare);
  }
}
