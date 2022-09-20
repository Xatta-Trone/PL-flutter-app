// To parse this JSON data, do
//
//     final userActivityData = userActivityDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserActivityData userActivityDataFromJson(String str) =>
    UserActivityData.fromJson(json.decode(str));

String userActivityDataToJson(UserActivityData data) =>
    json.encode(data.toJson());

class UserActivityData {
  UserActivityData({
    required this.data,
    required this.count,
  });

  final List<UserActivity> data;
  final int count;

  factory UserActivityData.fromJson(Map<String, dynamic> json) =>
      UserActivityData(
        data: List<UserActivity>.from(
            json["data"].map((x) => UserActivity.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
      };
}

class UserActivity {
  UserActivity({
    required this.id,
    required this.activity,
    required this.label,
    required this.createdAt,
  });

  final int id;
  final String activity;
  final String label;
  final DateTime createdAt;

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
        id: json["id"],
        activity: json["activity"],
        label: json["label"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity": activity,
        "label": label,
        "created_at": createdAt.toIso8601String(),
      };
}
