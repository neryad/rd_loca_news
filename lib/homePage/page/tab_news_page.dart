import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/widgets/news_card.dart';

class TabNewsPage extends StatefulWidget {
  const TabNewsPage({super.key});

  @override
  State<TabNewsPage> createState() => _TabNewsPageState();
}

class _TabNewsPageState extends State<TabNewsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final List<Map<String, dynamic>> _newspapers = [
    {
      'name': 'Diario Libre',
      'key': 'diariolibre',
      'icon': Icons.article_outlined,
    },
    {
      'name': 'El Nacional',
      'key': 'nacional',
      'icon': Icons.newspaper_outlined,
    },
    {
      'name': 'Listín Diario',
      'key': 'listin',
      'icon': Icons.feed_outlined,
    },
    {
      'name': 'Remolacha',
      'key': 'remolacha',
      'icon': Icons.description_outlined,
    },
    {
      'name': 'Nuevo Diario',
      'key': 'nuevoDiario',
      'icon': Icons.library_books_outlined,
    },
    {
      'name': 'El Hoy',
      'key': 'hoy',
      'icon': Icons.auto_stories_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _newspapers.length,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

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
                Icons.newspaper,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nery News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Noticias de RD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Column(
            children: [
              Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  padding: const EdgeInsets.all(4),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: _newspapers.map((newspaper) {
                    return Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              newspaper['icon'] as IconData,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(newspaper['name'] as String),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _newspapers.map((newspaper) {
          return NewsCard(
            newsPaper: newspaper['key'] as String,
          );
        }).toList(),
      ),
    );
  }
}
