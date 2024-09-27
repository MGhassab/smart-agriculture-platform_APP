import 'dart:convert';

CallProcessModel callProcessModelFromJson(String str) =>
    CallProcessModel.fromJson(json.decode(str));
String callProcessModelToJson(CallProcessModel data) =>
    json.encode(data.toJson());

class CallProcessModel {
  CallProcessModel({
    required this.updateTime,
    required this.timeToAction,
  });

  DateTime updateTime;
  DateTime timeToAction;

  factory CallProcessModel.fromJson(Map<String, dynamic> json) =>
      CallProcessModel(
        updateTime: DateTime.parse(json["update_time"]),
        timeToAction: DateTime.parse(json["time_to_action"]),
      );

  Map<String, dynamic> toJson() => {
        "update_time": updateTime.toIso8601String(),
        "time_to_action": timeToAction.toIso8601String(),
      };
}
