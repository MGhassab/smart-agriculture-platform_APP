import 'dart:convert';

List<UserDevicesModel> userDevicesModelFromJson(String str) =>
    List<UserDevicesModel>.from(
        json.decode(str).map((x) => UserDevicesModel.fromJson(x)));

String userDevicesModelToJson(List<UserDevicesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDevicesModel {
  UserDevicesModel({
    required this.id,
    required this.name,
    required this.typeNumber,
    required this.land,
  });

  int id;
  String name;
  int typeNumber;
  String land;

  factory UserDevicesModel.fromJson(Map<String, dynamic> json) =>
      UserDevicesModel(
        id: json["id"],
        name: json["name"],
        typeNumber: json["type_number"],
        land: json["land"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type_number": typeNumber,
        "land": land,
      };
}

DeviceModel deviceFromJson(String str) =>
    DeviceModel.fromJson(json.decode(str));
String deviceToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  DeviceModel({
    required this.id,
    required this.name,
    this.lastDeviceLogTime,
    required this.nextDeviceUpdate,
    required this.timeToAction,
    required this.spouts,
    required this.deviceOnline,
    required this.typeNumber,
    required this.networkCoverage,
    required this.land,
    required this.customerProcessButtons, //this.customerProcessButtons,
    this.weeklyOrderedProgramGroups,
    this.firstOngoingProgram,
  });

  int id;
  String name;
  DateTime? lastDeviceLogTime;
  DateTime nextDeviceUpdate;
  DateTime timeToAction;
  List<DeviceModelSpout> spouts;
  bool deviceOnline;
  int typeNumber;
  int networkCoverage;
  Land land;
  List<CustomerProcessButton>
      customerProcessButtons; //List<CustomerProcessButton>? customerProcessButtons;
  List<WeeklyOrderedProgramGroup>? weeklyOrderedProgramGroups;
  FirstOngoingProgram? firstOngoingProgram;

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        id: json["id"],
        name: json["name"],
        lastDeviceLogTime: json["last_device_log_time"] == null
            ? null
            : DateTime.parse(json["last_device_log_time"]),
        //lastDeviceLogTime: DateTime.parse(json["last_device_log_time"]),
        nextDeviceUpdate: DateTime.parse(json["next_device_update"]),
        timeToAction: DateTime.parse(json["time_to_action"]),
        spouts: List<DeviceModelSpout>.from(
            json["spouts"].map((x) => DeviceModelSpout.fromJson(x))),
        deviceOnline: json["device_online"],
        typeNumber: json["type_number"],
        networkCoverage: json["network_coverage"],
        land: Land.fromJson(json["land"]),
        customerProcessButtons: List<CustomerProcessButton>.from(
            json["customer_process_buttons"]
                .map((x) => CustomerProcessButton.fromJson(x))),
        //processButtons: json["process_buttons"] == null ? null : List<ProcessButton>.from(json["process_buttons"].map((x) => ProcessButton.fromJson(x))),
        weeklyOrderedProgramGroups: List<WeeklyOrderedProgramGroup>.from(
            json["weekly_ordered_program_groups"]
                .map((x) => WeeklyOrderedProgramGroup.fromJson(x))),
        //firstOngoingProgram: FirstOngoingProgram.fromJson(json["first_ongoing_program"]),
        firstOngoingProgram: json["first_ongoing_program"] == null
            ? null
            : FirstOngoingProgram.fromJson(json["first_ongoing_program"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        //"last_device_log_time": lastDeviceLogTime == null ? null : lastDeviceLogTime!.toIso8601String(),
        "last_device_log_time": lastDeviceLogTime!.toIso8601String(),
        "next_device_update": nextDeviceUpdate.toIso8601String(),
        "time_to_action": timeToAction.toIso8601String(),
        "spouts": List<dynamic>.from(spouts.map((x) => x.toJson())),
        "device_online": deviceOnline,
        "type_number": typeNumber,
        "network_coverage": networkCoverage,
        "land": land.toJson(),
        "customer_process_buttons":
            List<dynamic>.from(customerProcessButtons.map((x) => x.toJson())),
        //"process_buttons": processButtons == null ? null : List<dynamic>.from(processButtons!.map((x) => x.toJson())),
        "weekly_ordered_program_groups": List<dynamic>.from(
            weeklyOrderedProgramGroups!.map((x) => x.toJson())),
        //"first_ongoing_program": firstOngoingProgram!.toJson(),
        "first_ongoing_program":
            firstOngoingProgram == null ? null : firstOngoingProgram!.toJson(),
      };
}

class FirstOngoingProgram {
  FirstOngoingProgram({
    required this.index,
    required this.hasSynced,
  });

  int index;
  bool hasSynced;

  factory FirstOngoingProgram.fromJson(Map<String, dynamic> json) =>
      FirstOngoingProgram(
        index: json["index"],
        hasSynced: json["has_synced"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "has_synced": hasSynced,
      };
}

class Land {
  Land({
    required this.id,
    required this.name,
    this.location,
    required this.area,
    required this.longitude,
    required this.latitude,
    required this.city,
    required this.hasAdvanceTime,
  });

  int id;
  String name;
  String? location;
  int area;
  double longitude;
  double latitude;
  String city;
  bool hasAdvanceTime;

  factory Land.fromJson(Map<String, dynamic> json) => Land(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        area: json["area"],
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
        city: json["city"],
        hasAdvanceTime: json["has_advance_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "area": area,
        "longitude": longitude,
        "latitude": latitude,
        "city": city,
        "has_advance_time": hasAdvanceTime,
      };
}

class WeeklyOrderedProgramGroup {
  WeeklyOrderedProgramGroup({
    required this.id,
    required this.name,
    required this.repeatable,
    required this.interval,
    required this.start,
    required this.programs,
    required this.isOngoing,
    this.lastProgramCancel,
  });

  int id;
  String name;
  bool repeatable;
  String interval;
  DateTime start;
  List<Program> programs;
  bool isOngoing;
  DateTime? lastProgramCancel;

  factory WeeklyOrderedProgramGroup.fromJson(Map<String, dynamic> json) =>
      WeeklyOrderedProgramGroup(
        id: json["id"],
        name: json["name"],
        repeatable: json["repeatable"],
        interval: json["interval"],
        start: DateTime.parse(json["start"]),
        programs: List<Program>.from(
            json["programs"].map((x) => Program.fromJson(x))),
        isOngoing: json["is_ongoing"],
        lastProgramCancel: json["last_program_cancel"] == null
            ? null
            : DateTime.parse(json["last_program_cancel"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "repeatable": repeatable,
        "interval": interval,
        "start": start.toIso8601String(),
        "programs": List<dynamic>.from(programs.map((x) => x.toJson())),
        "is_ongoing": isOngoing,
        "last_program_cancel": lastProgramCancel == null
            ? null
            : lastProgramCancel!.toIso8601String(),
      };
}

class CustomerProcessButton {
  CustomerProcessButton({
    required this.id,
    required this.name,
    required this.number,
    required this.function,
    required this.isProcessing,
    required this.onInDevice,
    required this.isActive,
    required this.reachedTimeToAction,
    this.events,
  });

  int id;
  String name;
  int number;
  bool function;
  bool isProcessing;
  bool onInDevice;
  bool isActive;
  bool reachedTimeToAction;
  List<Event>? events;

  factory CustomerProcessButton.fromJson(Map<String, dynamic> json) =>
      CustomerProcessButton(
        id: json["id"],
        name: json["name"],
        number: json["number"],
        function: json["function"],
        onInDevice: json["on_in_device"],
        isProcessing: json["is_processing"],
        isActive: json["is_active"],
        reachedTimeToAction: json["reached_time_to_action"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "function": function,
        "on_in_device": onInDevice,
        "is_processing": isProcessing,
        "is_active": isActive,
        "reached_time_to_action": reachedTimeToAction,
        "events": List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class Event {
  Event({
    required this.id,
    required this.delay,
    required this.priority,
    required this.spoutChanges,
  });

  int id;
  String delay;
  int priority;
  List<ProgramSpout> spoutChanges;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        delay: json["delay"],
        priority: json["priority"],
        spoutChanges: List<ProgramSpout>.from(
            json["spout_changes"].map((x) => ProgramSpout.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delay": delay,
        "priority": priority,
        "spout_changes":
            List<dynamic>.from(spoutChanges.map((x) => x.toJson())),
      };
}

class DeviceModelSpout {
  DeviceModelSpout({
    required this.id,
    required this.name,
    required this.number,
    required this.isOn,
    required this.isWatering,
    required this.isActive,
  });

  int id;
  String name;
  int number;
  bool isOn;
  bool isWatering;
  bool isActive;

  factory DeviceModelSpout.fromJson(Map<String, dynamic> json) =>
      DeviceModelSpout(
        id: json["id"],
        name: json["name"],
        number: json["number"],
        isOn: json["isOn"],
        isWatering: json["is_watering"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "isOn": isOn,
        "is_watering": isWatering,
        "is_active": isActive,
      };
}

AddProgramModel addProgramModelFromJson(String str) =>
    AddProgramModel.fromJson(json.decode(str));
String addProgramModelToJson(AddProgramModel data) =>
    json.encode(data.toJson());

class AddProgramModel {
  AddProgramModel({
    required this.id,
    required this.name,
    required this.repeatable,
    required this.interval,
    required this.start,
    required this.programs,
    required this.isOngoing,
  });

  int id;
  String name;
  bool repeatable;
  String interval;
  String start;
  List<Program> programs;
  bool isOngoing;

  factory AddProgramModel.fromJson(Map<String, dynamic> json) =>
      AddProgramModel(
        id: json["id"],
        name: json["name"],
        repeatable: json["repeatable"],
        interval: json["interval"],
        start: json["start"],
        programs: List<Program>.from(
            json["programs"].map((x) => Program.fromJson(x))),
        isOngoing: json["is_ongoing"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "repeatable": repeatable,
        "interval": interval,
        "start": start,
        "programs": List<dynamic>.from(programs.map((x) => x.toJson())),
        "is_ongoing": isOngoing,
      };
}

class ProgramTemp {
  ProgramTemp({
    required this.number,
    required this.delay,
    required this.spouts,
  });

  int number;
  String delay;
  List<ProgramSpout> spouts; //...

  factory ProgramTemp.fromJson(Map<String, dynamic> json) => ProgramTemp(
        number: json["number"],
        delay: json["delay"],
        spouts: List<ProgramSpout>.from(
            json["spouts"].map((x) => ProgramSpout.fromJson(x))), //...
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "delay": delay,
        "spouts": List<dynamic>.from(spouts.map((x) => x.toJson())),
      };
}

class Program {
  Program({
    required this.id,
    this.programGroup,
    required this.number,
    required this.delay,
    this.changeSpouts,
  });

  int id;
  int? programGroup;
  int number;
  String delay;
  List<ProgramSpout>? changeSpouts;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        id: json["id"],
        programGroup: json["program_group"],
        number: json["number"],
        delay: json["delay"],
        changeSpouts: List<ProgramSpout>.from(
            json["change_spouts"].map((x) => ProgramSpout.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_group": programGroup,
        "number": number,
        "delay": delay,
        "change_spouts":
            List<dynamic>.from(changeSpouts!.map((x) => x.toJson())),
      };
}

/*class Program {
  Program({
    required this.id,
    required this.number,
    required this.delay,
    required this.spouts,
  });

  int id;
  int number;
  String delay;
  List<ProgramSpout>? spouts;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    delay: json["delay"] == null ? null : json["delay"],
    spouts: List<ProgramSpout>.from(json["spouts"].map((x) => ProgramSpout.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "delay": delay == null ? null : delay,
    "spouts": spouts == null ? null : List<dynamic>.from(spouts!.map((x) => x.toJson())),
  };
}*/

class ProgramSpout {
  ProgramSpout({
    required this.id,
    required this.spout,
    required this.isOn,
  });

  int id;
  int spout;
  bool isOn;

  factory ProgramSpout.fromJson(Map<String, dynamic> json) => ProgramSpout(
        id: json["id"],
        spout: json["spout"],
        isOn: json["is_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "spout": spout,
        "is_on": isOn,
      };
}
