import 'dart:convert';

VerifyModel verifyModelFromJson(String str) =>
    VerifyModel.fromJson(json.decode(str));
String verifyModelToJson(VerifyModel data) => json.encode(data.toJson());

class VerifyModel {
  VerifyModel({
    required this.token,
    required this.username,
    required this.hasRegisteredLand,
  });

  String token;
  String username;
  bool hasRegisteredLand;

  factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
        token: json["token"],
        username: json["username"],
        hasRegisteredLand: json["has_registered_land"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "has_registered_land": hasRegisteredLand,
      };
}
