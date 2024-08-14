// To parse this JSON data, do
//
//     final detailsResponse = detailsResponseFromJson(jsonString);

import 'dart:convert';

DetailsResponse detailsResponseFromJson(String str) =>
    DetailsResponse.fromJson(json.decode(str));

String detailsResponseToJson(DetailsResponse detail) =>
    json.encode(detail.toJson());

class DetailsResponse {
  bool ok;
  Detail detail;

  DetailsResponse({
    required this.ok,
    required this.detail,
  });

  factory DetailsResponse.fromJson(Map<String, dynamic> json) =>
      DetailsResponse(
        ok: json["ok"],
        detail: Detail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "data": detail.toJson(),
      };
}

class Detail {
  String url;
  String title;
  String description;
  String image;
  String author;
  String favicon;
  String content;
  DateTime published;
  String type;
  String source;
  List<String> links;
  int ttr;

  Detail({
    required this.url,
    required this.title,
    required this.description,
    required this.image,
    required this.author,
    required this.favicon,
    required this.content,
    required this.published,
    required this.type,
    required this.source,
    required this.links,
    required this.ttr,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        url: json["url"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        author: json["author"],
        favicon: json["favicon"],
        content: json["content"],
        published: DateTime.parse(json["published"]),
        type: json["type"],
        source: json["source"],
        links: List<String>.from(json["links"].map((x) => x)),
        ttr: json["ttr"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "description": description,
        "image": image,
        "author": author,
        "favicon": favicon,
        "content": content,
        "published": published.toIso8601String(),
        "type": type,
        "source": source,
        "links": List<dynamic>.from(links.map((x) => x)),
        "ttr": ttr,
      };
}
