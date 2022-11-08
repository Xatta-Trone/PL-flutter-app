// To parse this JSON data, do
//
//     final countData = countDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:plandroid/globals/globals.dart';

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


  // String formatUser() {
  //   return Globals.getRounded(int.parse(users));
  // }

  // String formatBooks() {
  //   return Globals.getRounded(int.parse(books));
  // }

  // String formatSoftwares() {
  //   return Globals.getRounded(int.parse(softwares));
  // }

  // String formatDownloads() {
  //   return Globals.getRounded(downloads);
  // }

  String formatUser() {
    return Globals.getRounded(users);
  }

  String formatBooks() {
    return Globals.getRounded(books);
  }

  String formatSoftwares() {
    return Globals.getRounded(softwares);
  }

  String formatDownloads() {
    return Globals.getRounded(downloads);
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
