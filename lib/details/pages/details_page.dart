import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rd_loca_news/details/models/details_model.dart';
import 'package:rd_loca_news/shared/ad_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsNewsPage extends StatefulWidget {
  final Detail newDetails;
  const DetailsNewsPage({super.key, required this.newDetails});

  @override
  State<DetailsNewsPage> createState() => _DetailsNewsPageState();
}

class _DetailsNewsPageState extends State<DetailsNewsPage> {
  BannerAd? _bannerAd;
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
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(
            detail: widget.newDetails,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              widget.newDetails.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 5,
              textAlign: TextAlign.center,
            )),
            _Overview(
              overView: widget.newDetails.content,
            ),
            _AuthorInfo(
              author: widget.newDetails.author,
              date: widget.newDetails.published.toString(),
              source: widget.newDetails.source,
            ),
            if (_bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _launchUrl(widget.newDetails.url);
                    },
                    child: const Text(
                      'ir a la fuente',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        final messageToShare =
                            '¡Últimas noticias: ${widget.newDetails.title}! 📰\n 📰 ¡Mantente al día con nuestra nueva app de noticias! 📱\n👉 ${widget.newDetails.url}\n\n¡Descarga NeryNews ya y no te pierdas ninguna noticia! 🚀📲';
                        Share.share(messageToShare);
                      },
                      icon: const Icon(Icons.share))
                ],
              ),
            )
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({required this.detail});
  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(10),
          color: Colors.black12,
        ),
        background: FadeInImage(
          placeholder: const AssetImage('/assets/epic-loading.gif'),
          image: NetworkImage(detail.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overView;

  const _Overview({required this.overView});
  @override
  Widget build(BuildContext context) {
    //final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          overView,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyLarge,
          // style: textTheme.subtitle1,
        ),
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final String author;
  final String date;
  final String source;

  const _AuthorInfo({
    required this.author,
    required this.date,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Autor: $author', style: const TextStyle(fontSize: 14)),
          Text('Fecha publicación: $date',
              style: const TextStyle(fontSize: 14)),
          Text('Fuente: $source', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
