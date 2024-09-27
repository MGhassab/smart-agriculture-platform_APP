import 'dart:convert';

VerifyRequestModel verifyRequestModelFromJson(String str) =>
    VerifyRequestModel.fromJson(json.decode(str));
String verifyRequestModelToJson(VerifyRequestModel data) =>
    json.encode(data.toJson());

class VerifyRequestModel {
  VerifyRequestModel({
    required this.username,
    required this.expire,
  });

  String username;
  String expire;

  factory VerifyRequestModel.fromJson(Map<String, dynamic> json) =>
      VerifyRequestModel(
        username: json["username"],
        expire: json["expire"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "expire": expire,
      };
}
