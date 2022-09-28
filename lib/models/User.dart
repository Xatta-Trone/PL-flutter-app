// ignore: file_names
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.accessToken,
    required this.user,
  });

  final String accessToken;
  final UserClass user;

  factory User.fromJson(Map<String, dynamic> json) => User(
        accessToken: json["access_token"],
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "user": user.toJson(),
      };
}

class UserClass {
  UserClass({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.emailVerifiedAt,
    required this.userLetter,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.whitelisted,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final String email;
  final String studentId;
  final dynamic emailVerifiedAt;
  final String userLetter;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int whitelisted;
  final dynamic deletedAt;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        studentId: json["student_id"],
        emailVerifiedAt: json["email_verified_at"],
        userLetter: json["user_letter"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        whitelisted: json["whitelisted"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "student_id": studentId,
        "email_verified_at": emailVerifiedAt,
        "user_letter": userLetter,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "whitelisted": whitelisted,
        "deleted_at": deletedAt,
      };
}
