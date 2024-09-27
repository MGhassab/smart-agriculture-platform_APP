import 'dart:convert';

CancelProgramModel cancelProgramModelFromJson(String str) =>
    CancelProgramModel.fromJson(json.decode(str));

String cancelProgramModelToJson(CancelProgramModel data) =>
    json.encode(data.toJson());

class CancelProgramModel {
  CancelProgramModel({
    required this.msg,
  });

  String msg;

  factory CancelProgramModel.fromJson(Map<String, dynamic> json) =>
      CancelProgramModel(
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
      };
}
