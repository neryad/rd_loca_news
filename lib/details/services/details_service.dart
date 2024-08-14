import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rd_loca_news/details/models/details_model.dart';

Future<Detail> getDetailsOfNew(String url) async {
  final dio = Dio();

  var apiUrl = 'https://api-scrapping-news-rd.onrender.com/api/details';
  final body = {"url": url};
  try {
    final response = await dio.post(apiUrl, data: body);

    final jsonResponse = Detail.fromJson(response.data["data"]);
    log('$jsonResponse');
    return jsonResponse;
  } catch (e) {
    log('$e');
    rethrow;
  }
}
