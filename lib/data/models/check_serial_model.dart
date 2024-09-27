import 'dart:convert';

CheckSerialModel checkSerialModelFromJson(String str) =>
    CheckSerialModel.fromJson(json.decode(str));
String checkSerialModelToJson(CheckSerialModel data) =>
    json.encode(data.toJson());

class CheckSerialModel {
  CheckSerialModel({
    required this.hasLand,
    required this.hasDevice,
  });

  bool hasLand;
  bool hasDevice;

  factory CheckSerialModel.fromJson(Map<String, dynamic> json) =>
      CheckSerialModel(
        hasLand: json["has_land"],
        hasDevice: json["has_device"],
      );

  Map<String, dynamic> toJson() => {
        "has_land": hasLand,
        "has_device": hasDevice,
      };
}
