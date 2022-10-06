import 'dart:convert';

DeptNotice deptNoticeFromJson(String str) =>
    DeptNotice.fromJson(json.decode(str));

String deptNoticeToJson(DeptNotice data) => json.encode(data.toJson());

class DeptNotice {
  DeptNotice({
    required this.message,
    required this.status,
    required this.data,
  });

  final String message;
  final String status;
  final Data data;

  factory DeptNotice.fromJson(Map<String, dynamic> json) => DeptNotice(
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
    required this.key,
    required this.value,
  });

  final String key;
  final String value;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
