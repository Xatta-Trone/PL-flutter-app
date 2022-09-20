// To parse this JSON data, do
//
//     final userDevicesData = userDevicesDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserDevicesData userDevicesDataFromJson(String str) =>
    UserDevicesData.fromJson(json.decode(str));

String userDevicesDataToJson(UserDevicesData data) =>
    json.encode(data.toJson());

class UserDevicesData {
  UserDevicesData({
    required this.data,
    required this.count,
  });

  final List<UserDevice> data;
  final int count;

  factory UserDevicesData.fromJson(Map<String, dynamic> json) =>
      UserDevicesData(
        data: List<UserDevice>.from(
            json["data"].map((x) => UserDevice.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
      };
}

class UserDevice {
  UserDevice({
    required this.id,
    required this.userIp,
    required this.location,
    required this.device,
    required this.fingerprint,
    required this.updatedAt,
  });

  final int id;
  final String userIp;
  final String location;
  final String device;
  final String? fingerprint;
  final DateTime updatedAt;

  factory UserDevice.fromJson(Map<String, dynamic> json) => UserDevice(
        id: json["id"],
        userIp: json["user_ip"],
        location: json["location"],
        device: json["device"],
        fingerprint: json["fingerprint"] ?? '',
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_ip": userIp,
        "location": location,
        "device": device,
        "fingerprint": fingerprint ?? '',
        "updated_at": updatedAt.toIso8601String(),
      };
}
