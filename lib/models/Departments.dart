// To parse this JSON data, do
//
//     final departmentData = departmentDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DepartmentData departmentDataFromJson(String str) =>
    DepartmentData.fromJson(json.decode(str));

String departmentDataToJson(DepartmentData data) => json.encode(data.toJson());

class DepartmentData {
  DepartmentData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final List<Department> data;

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
        message: json["message"],
        status: json["status"],
        data: List<Department>.from(
            json["data"].map((x) => Department.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Department {
  Department({
    required this.name,
    required this.slug,
    required this.image,
    required this.id,
  });

  final String name;
  final String slug;
  final String image;
  final int id;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "image": image,
        "id": id,
      };
}
