// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  PostData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final Data data;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
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
    required this.courseName,
    required this.slug,
    required this.activePosts,
  });

  final int id;
  final String courseName;
  final String slug;
  final List<ActivePost> activePosts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        courseName: json["course_name"],
        slug: json["slug"],
        activePosts: List<ActivePost>.from(
            json["active_posts"].map((x) => ActivePost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_name": courseName,
        "slug": slug,
        "active_posts": List<dynamic>.from(activePosts.map((x) => x.toJson())),
      };
}

class ActivePost {
  ActivePost({
    required this.id,
    required this.name,
    required this.courseId,
    required this.link,
  });

  final int id;
  final String name;
  final int courseId;
  final String link;

  factory ActivePost.fromJson(Map<String, dynamic> json) => ActivePost(
        id: json["id"],
        name: json["name"],
        courseId: json["course_id"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course_id": courseId,
        "link": link,
      };
}
