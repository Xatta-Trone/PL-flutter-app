// To parse this JSON data, do
//
//     final courseData = courseDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CourseData courseDataFromJson(String str) =>
    CourseData.fromJson(json.decode(str));

String courseDataToJson(CourseData data) => json.encode(data.toJson());

class CourseData {
  CourseData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final Data data;

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
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
    required this.departmentId,
    required this.course,
    required this.department,
  });

  final int id;
  final String name;
  final int departmentId;
  final List<Course> course;
  final Department department;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        departmentId: json["department_id"],
        course:
            List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
        department: Department.fromJson(json["department"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "department_id": departmentId,
        "course": List<dynamic>.from(course.map((x) => x.toJson())),
        "department": department.toJson(),
      };
}

class Course {
  Course({
    required this.id,
    required this.courseName,
    required this.slug,
    required this.levelTermId,
  });

  final int id;
  final String courseName;
  final String slug;
  final int levelTermId;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        courseName: json["course_name"],
        slug: json["slug"],
        levelTermId: json["level_term_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_name": courseName,
        "slug": slug,
        "level_term_id": levelTermId,
      };
}

class Department {
  Department({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
