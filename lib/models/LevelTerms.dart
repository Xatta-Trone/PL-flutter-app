// To parse this JSON data, do
//
//     final levelTermData = levelTermDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LevelTermData levelTermDataFromJson(String str) =>
    LevelTermData.fromJson(json.decode(str));

String levelTermDataToJson(LevelTermData data) => json.encode(data.toJson());

class LevelTermData {
  LevelTermData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final Data data;

  factory LevelTermData.fromJson(Map<String, dynamic> json) => LevelTermData(
        message: json["message"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.canBeAccessedBy,
    required this.levelterms,
  });

  final int id;
  final String name;
  final String canBeAccessedBy;
  final List<Levelterm> levelterms;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        canBeAccessedBy: json["can_be_accessed_by"],
        levelterms: List<Levelterm>.from(
            json["levelterms"].map((x) => Levelterm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "can_be_accessed_by": canBeAccessedBy,
        "levelterms": List<dynamic>.from(levelterms.map((x) => x.toJson())),
      };
}

class Levelterm {
  Levelterm({
    required this.id,
    required this.name,
    required this.slug,
    required this.departmentId,
  });

  final int id;
  final String name;
  final String slug;
  final int departmentId;

  factory Levelterm.fromJson(Map<String, dynamic> json) => Levelterm(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        departmentId: json["department_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "department_id": departmentId,
      };
}
