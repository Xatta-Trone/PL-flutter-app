// To parse this JSON data, do
//
//     final courseDataForSearch = courseDataForSearchFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:plandroid/globals/globals.dart';

CourseDataForSearch courseDataForSearchFromJson(String str) =>
    CourseDataForSearch.fromJson(json.decode(str));

String courseDataForSearchToJson(CourseDataForSearch data) =>
    json.encode(data.toJson());

class CourseDataForSearch {
  CourseDataForSearch({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final List<Course> data;

  factory CourseDataForSearch.fromJson(Map<String, dynamic> json) =>
      CourseDataForSearch(
        message: json["message"],
        status: json["status"],
        data: List<Course>.from(json["data"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Course {
  Course({
    required this.courseName,
    required this.slug,
    required this.id,
    required this.departmentId,
    required this.levelTermId,
  });

  final String courseName;
  final String slug;
  final int id;
  final int departmentId;
  final int levelTermId;

  String userAsString() {
    return '$courseName (${Globals.generateCourseName(slug).toUpperCase()})';
  }

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseName: json["course_name"],
        slug: json["slug"],
        id: json["id"],
        departmentId: json["department_id"],
        levelTermId: json["level_term_id"],
      );

  Map<String, dynamic> toJson() => {
        "course_name": courseName,
        "slug": slug,
        "id": id,
        "department_id": departmentId,
        "level_term_id": levelTermId,
      };
}
