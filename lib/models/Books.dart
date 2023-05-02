import 'dart:convert';

BooksList booksListFromJson(String str) => BooksList.fromJson(json.decode(str));

String booksListToJson(BooksList data) => json.encode(data.toJson());

class BooksList {
  BooksList({
    required this.data,
    required this.count,
  });

  final List<Book> data;
  final int count;

  factory BooksList.fromJson(Map<String, dynamic> json) => BooksList(
        data: List<Book>.from(json["data"].map((x) => Book.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
      };
}

class Book {
  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.status,
    required this.link,
  });

  final int id;
  final String name;
  final String? author;
  final String status;
  final String link;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        name: json["name"],
        author: json["author"],
        status: json["status"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author": author,
        "status": status,
        "link": link,
      };
}
