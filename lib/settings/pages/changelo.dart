import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rd_loca_news/settings/services/changlogServices.dart/chanagelos_services.dart';

class ChangeLog extends StatefulWidget {
  const ChangeLog({super.key});

  @override
  State<ChangeLog> createState() => _ChangeLogState();
}

class _ChangeLogState extends State<ChangeLog> {
  String? markdownData;

  final MarkdownService _markdownService = MarkdownService();

  @override
  void initState() {
    super.initState();
    _fetchMarkdown();
  }

  Future<void> _fetchMarkdown() async {
    final data = await _markdownService.fetchMarkdown(
      'https://raw.githubusercontent.com/neryad/rd_loca_news/refs/heads/main/CHANGELOG.md',
    );
    setState(() {
      markdownData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('ChangeLogs'),
      ),
      body: markdownData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Markdown(
              data: markdownData!,
              // styleSheet: MarkdownStyleSheet(
              //   h1: const TextStyle(fontSize: 24),
              //   h2: const TextStyle(fontSize: 20),
              //   a: const TextStyle(color: Colors.blue),
              // ),
            ),
    );
  }
}
