import 'dart:convert';

NewsResponse newsResponseFromJson(String str) =>
    NewsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String newsResponseToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  int status;
  bool ok;
  List<News> data;

  NewsResponse({
    required this.status,
    required this.ok,
    required this.data,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json["status"] as int,
        ok: json["ok"] as bool,
        data: List<News>.from((json["data"] as List<dynamic>).map((x) => News.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "ok": ok,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class News {
  String title;
  String url;
  String img;

  News({
    required this.title,
    required this.url,
    required this.img,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        title: json["title"] as String,
        url: json["url"] as String,
        img: json["img"] as String,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "img": img,
      };
}
