import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewer extends StatefulWidget {
  final String fileRoute;

  const MarkdownViewer({super.key, required this.fileRoute});
  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  String markdownContent = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdownFile();
  }

  // Método para cargar el archivo Markdown desde los assets
  Future<void> _loadMarkdownFile() async {
    final String content = await rootBundle.loadString(widget.fileRoute);
    setState(() {
      markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start, // Alineado a la izquierda
          children: [
            Text('Información'),
            SizedBox(width: 10),
            Icon(Icons.info_outline_rounded),
          ],
        ),
        centerTitle: false, // Evita que el contenido esté centrado en el AppBar
      ),
      body: markdownContent.isNotEmpty
          ? Markdown(data: markdownContent)
          : Center(
              child:
                  CircularProgressIndicator()), // Cargando mientras se lee el archivo
    );
  }
}
