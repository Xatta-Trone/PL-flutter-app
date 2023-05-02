import 'package:plandroid/globals/globals.dart';
import 'dart:convert';



List<SearchData> searchDataFromJson(String str) =>
    List<SearchData>.from(json.decode(str).map((x) => SearchData.fromJson(x)));

String searchDataToJson(List<SearchData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchData {
  SearchData({
    required this.id,
    required this.name,
    required this.author,
    required this.departmentSlug,
    required this.levelTermSlug,
    required this.courseId,
    required this.postType,
    required this.link,
    required this.description,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? author;
  final String? departmentSlug;
  final String? levelTermSlug;
  final int? courseId;
  final String postType;
  final String link;
  final String? description;
  final DateTime createdAt;

  String getAuthor({String courseSlug = ''}) {
    if (postType == 'post') {
      return "${departmentSlug?.toUpperCase()}/${levelTermSlug?.toUpperCase()}/${Globals.generateCourseName(courseSlug.trim()).toUpperCase()}";
    }
    return author ?? name;
  }

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        id: json["id"],
        name: json["name"],
        author: json["author"],
        departmentSlug: json["department_slug"],
        levelTermSlug: json["level_term_slug"],
        courseId: json["course_id"],
        postType: json["post_type"],
        link: json["link"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author": author,
        "department_slug": departmentSlug,
        "level_term_slug": levelTermSlug,
        "course_id": courseId,
        "post_type": postType,
        "link": link,
        "description": description,
        "created_at": createdAt.toIso8601String(),
      };
}
