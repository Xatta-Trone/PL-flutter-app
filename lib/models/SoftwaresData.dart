import 'dart:convert';

SoftwaresData softwaresDataFromJson(String str) =>
    SoftwaresData.fromJson(json.decode(str));

String softwaresDataToJson(SoftwaresData data) => json.encode(data.toJson());

class SoftwaresData {
  SoftwaresData({
    required this.data,
    required this.count,
  });

  final List<Software> data;
  final int count;

  factory SoftwaresData.fromJson(Map<String, dynamic> json) => SoftwaresData(
        data:
            List<Software>.from(json["data"].map((x) => Software.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
      };
}

class Software {
  Software({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.link,
    required this.author,
  });

  final int id;
  final String name;
  final String description;
  final String status;
  final String link;
  final String? author;

  factory Software.fromJson(Map<String, dynamic> json) => Software(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
        link: json["link"],
        author: json["author"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "status": status,
        "link": link,
        "author": author ?? null,
      };
}
