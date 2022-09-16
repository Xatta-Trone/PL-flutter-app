// To parse this JSON data, do
//
//     final testimonialData = testimonialDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TestimonialData testimonialDataFromJson(String str) =>
    TestimonialData.fromJson(json.decode(str));

String testimonialDataToJson(TestimonialData data) =>
    json.encode(data.toJson());

class TestimonialData {
  TestimonialData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final List<Testimonial> data;

  factory TestimonialData.fromJson(Map<String, dynamic> json) =>
      TestimonialData(
        message: json["message"],
        status: json["status"],
        data: List<Testimonial>.from(
            json["data"].map((x) => Testimonial.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Testimonial {
  Testimonial({
    required this.name,
    required this.userLetter,
    required this.deptBatch,
    required this.message,
  });

  final String name;
  final String userLetter;
  final String deptBatch;
  final String message;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        name: json["name"],
        userLetter: json["user_letter"],
        deptBatch: json["dept_batch"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "user_letter": userLetter,
        "dept_batch": deptBatch,
        "message": message,
      };
}
