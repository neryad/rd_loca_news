import 'package:dio/dio.dart';

class MarkdownService {
  final Dio _dio = Dio();

  Future<String?> fetchMarkdown(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return 'Error al cargar el archivo Markdown.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
