// To parse this JSON data, do
//
//     final detailsResponse = detailsResponseFromJson(jsonString);

import 'dart:convert';

DetailsResponse detailsResponseFromJson(String str) =>
    DetailsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

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
        ok: json["ok"] as bool,
        detail: Detail.fromJson(json["data"] as Map<String, dynamic>),
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
        url: json["url"] as String,
        title: json["title"] as String,
        description: json["description"] as String,
        image: json["image"] as String,
        author: json["author"] as String,
        favicon: json["favicon"] as String,
        content: json["content"] as String,
        published: DateTime.parse(json["published"] as String),
        type: json["type"] as String,
        source: json["source"] as String,
        links: List<String>.from((json["links"] as List<dynamic>).map((x) => x as String)),
        ttr: json["ttr"] as int,
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
