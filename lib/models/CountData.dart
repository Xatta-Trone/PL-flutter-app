// To parse this JSON data, do
//
//     final countData = countDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CountData countDataFromJson(String str) => CountData.fromJson(json.decode(str));

String countDataToJson(CountData data) => json.encode(data.toJson());

class CountData {
  CountData({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final Data data;

  factory CountData.fromJson(Map<String, dynamic> json) => CountData(
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
    required this.users,
    required this.books,
    required this.softwares,
    required this.downloads,
  });

  final int users;
  final int books;
  final int softwares;
  final int downloads;

  String formatUser() {
    if (users < 1000) return users.toString();
    return "${(users / 1000).round().toStringAsFixed(1).toString()}K";
  }

  String formatBooks() {
    if (books < 1000) return books.toString();
    return "${(books / 1000).round().toStringAsFixed(1).toString()}K";
  }

  String formatSoftwares() {
    if (softwares < 1000) return softwares.toString();
    return "${(softwares / 1000).round().toStringAsFixed(1).toString()}K";
  }

  String formatDownloads() {
    if (downloads < 1000) return downloads.toString();
    return "${(downloads / 1000).round().toStringAsFixed(1).toString()}K";
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: json["users"],
        books: json["books"],
        softwares: json["softwares"],
        downloads: json["downloads"],
      );

  Map<String, dynamic> toJson() => {
        "users": users,
        "books": books,
        "softwares": softwares,
        "downloads": downloads,
      };
}
