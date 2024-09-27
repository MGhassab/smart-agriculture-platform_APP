//import 'package:baghyar/data/models/DeviceModel.dart';

class ProgramGroup {
  ProgramGroup({
    required this.id,
    this.name = "NONE",
    required this.startTime,
    required this.durationTime,
    this.repeatable = true,
    this.isOngoing = false,
    this.isCancelled = false,
    required this.interval,
    this.spoutGroupValue,
    this.intervalGroupValue,
    this.isInWeek = true,
    //this.lastProgramCancel,
    //required this.programs,
  });

  bool isInWeek;
  int id;
  String interval;
  int? spoutGroupValue;
  int? intervalGroupValue;
  bool repeatable;
  bool isOngoing;
  bool isCancelled;
  String name;
  DateTime durationTime;
  DateTime startTime;
  //DateTime? lastProgramCancel;
  //List<Program> programs;
}
