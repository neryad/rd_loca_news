import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rd_loca_news/details/models/details_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsNewsPage extends StatefulWidget {
  final Detail newDetails;
  const DetailsNewsPage({super.key, required this.newDetails});

  @override
  State<DetailsNewsPage> createState() => _DetailsNewsPageState();
}

class _DetailsNewsPageState extends State<DetailsNewsPage> {
  // BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(detail: widget.newDetails),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título con mejor espaciado y diseño
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    widget.newDetails.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                // Metadata con chips modernos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _MetadataChips(
                    author: widget.newDetails.author,
                    date: widget.newDetails.published.toString(),
                    source: widget.newDetails.source,
                  ),
                ),

                const SizedBox(height: 20),

                // Contenido con mejor tipografía
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.newDetails.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botones de acción mejorados
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: _ActionButtons(
                    onSourceTap: () => _launchUrl(widget.newDetails.url),
                    onShareTap: () => _shareNews(widget.newDetails),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareNews(Detail detail) {
    final messageToShare =
        '¡Últimas noticias: ${detail.title}! 📰\n📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${detail.url}\n\n¡Descarga NeryNews ya y no te pierdas ninguna noticia! 🚀📲';
    Share.share(messageToShare);
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({required this.detail});
  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 280,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage(
              placeholder: const AssetImage('/assets/epic-loading.gif'),
              image: NetworkImage(detail.image),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 64),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataChips extends StatelessWidget {
  final String author;
  final String date;
  final String source;

  const _MetadataChips({
    required this.author,
    required this.date,
    required this.source,
  });

  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.person, size: 16),
          label: Text(
            author.isEmpty ? 'Anónimo' : author,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        Chip(
          avatar: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            _formatDate(date),
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        Chip(
          avatar: const Icon(Icons.source, size: 16),
          label: Text(
            source,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onSourceTap;
  final VoidCallback onShareTap;

  const _ActionButtons({
    required this.onSourceTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onSourceTap,
            icon: const Icon(Icons.link),
            label: const Text('Ver Fuente'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: onShareTap,
          icon: const Icon(Icons.share),
          label: const Text('Compartir'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
