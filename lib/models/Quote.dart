// To parse this JSON data, do
//
//     final quote = quoteFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Quote quoteFromJson(String str) => Quote.fromJson(json.decode(str));

String quoteToJson(Quote data) => json.encode(data.toJson());

class Quote {
  Quote({required this.message, required this.status, required this.data});

  String message;
  String status;
  Data data;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
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
    required this.quote,
    required this.author,
  });

  String quote;
  String author;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        quote: json["quote"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "quote": quote,
        "author": author,
      };
}
