import 'dart:convert';

NewsResponse newsResponseFromJson(String str) =>
    NewsResponse.fromJson(json.decode(str));

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
        status: json["status"],
        ok: json["ok"],
        data: List<News>.from(json["data"].map((x) => News.fromJson(x))),
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
        title: json["title"],
        url: json["url"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "img": img,
      };
}
