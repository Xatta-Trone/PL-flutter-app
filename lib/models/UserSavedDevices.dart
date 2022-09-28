import 'dart:convert';

UserSavedDevices userSavedDevicesFromMap(String str) =>
    UserSavedDevices.fromMap(json.decode(str));

String userSavedDevicesToMap(UserSavedDevices data) =>
    json.encode(data.toMap());

class UserSavedDevices {
  UserSavedDevices({
    required this.maxAllowedDevice,
    required this.devices,
  });

  final String maxAllowedDevice;
  final List<Device> devices;

  factory UserSavedDevices.fromMap(Map<String, dynamic> json) =>
      UserSavedDevices(
        maxAllowedDevice: json["max_allowed_device"],
        devices:
            List<Device>.from(json["devices"].map((x) => Device.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "max_allowed_device": maxAllowedDevice,
        "devices": List<dynamic>.from(devices.map((x) => x.toMap())),
      };
}

class Device {
  Device({
    required this.id,
    required this.userId,
    required this.ipAddress,
    required this.location,
    required this.device,
    required this.fingerprint,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final String ipAddress;
  final String location;
  final String device;
  final String fingerprint;
  final String platform;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Device.fromMap(Map<String, dynamic> json) => Device(
        id: json["id"],
        userId: json["user_id"],
        ipAddress: json["ip_address"],
        location: json["location"],
        device: json["device"],
        fingerprint: json["fingerprint"],
        platform: json["platform"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "ip_address": ipAddress,
        "location": location,
        "device": device,
        "fingerprint": fingerprint,
        "platform": platform,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
