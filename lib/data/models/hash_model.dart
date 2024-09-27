import 'dart:convert';

HashModel hashModelFromJson(String str) => HashModel.fromJson(json.decode(str));
String hashModelToJson(HashModel data) => json.encode(data.toJson());

class HashModel {
  HashModel({
    required this.hash,
  });

  String hash;

  factory HashModel.fromJson(Map<String, dynamic> json) => HashModel(
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
      };
}
