import 'dart:convert';

import 'package:baghyar/data/models/call_progress_model.dart';
import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/data/models/hash_model.dart';
import 'package:baghyar/data/models/program_group.dart';
import 'package:baghyar/data/models/week.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'day.dart';
import 'loading_indicator.dart';

class Device {
  Device({required this.userDevice, required this.token});

  Future<DeviceModel> getDevice(int deviceID) async {
    final String apiUrl = 'http://baghyar.darkube.app/panel/api/u/device/' +
        deviceID.toString() +
        '/';
    //final String backupUrl = 'http://37.152.181.206/panel/api/u/register_land_and_device/';
    Map<String, String> headers = {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json'
    };
    //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    //server can not process the request
    if (response.statusCode == 200) {
      final DeviceModel temp =
          deviceFromJson(const Utf8Decoder().convert(response.bodyBytes));
      week = _buildWeek(temp.weeklyOrderedProgramGroups, temp.typeNumber);
      return temp;
    } else {
      // GITHUB print('Get device error');
      throw Exception('Failed!');
    }
  }

  Future callProcess(int button, bool condition) async {
    final String apiUrl =
        'http://baghyar.darkube.app/panel/api/u/call_process/' +
            userDevice.id.toString() +
            '/' +
            button.toString() +
            '/';
    Map<String, String> headers = {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json'
    };
    final msg = jsonEncode(<String, dynamic>{"function": condition});
    //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
    //print(Utf8Decoder().convert(response.bodyBytes));
    //server can not process the request
    if (response.statusCode == 200) {
      CallProcessModel callProcessModel = callProcessModelFromJson(
          const Utf8Decoder().convert(response.bodyBytes));
      if (buttonLoading[button - 1].isNotProcessing) {
        // GITHUB print('YAAA');
        if (condition == true) {
          buttonLoading[button - 1].isStarted = true;
          //buttonLoading[button - 1].isCancelled = false;
        } else {
          buttonLoading[button - 1].isCancelled = true;
          //buttonLoading[button - 1].isStarted = false;
        }
        buttonLoading[button - 1].start(callProcessModel.updateTime,
            callProcessModel.timeToAction, false, false);
      }
      try {
        await refreshDevice();
      } catch (e) {
        // GITHUB print(e);
      }
    } else {
      throw Exception('Failed!');
    }
  }

  bool isHashChanged(String newHash) {
    if (newHash != hash) {
      hash = newHash;
      // GITHUB print('Hash changed');
      return true;
    }
    return false;
  }

  Week _buildWeek(
      List<WeeklyOrderedProgramGroup>? weeklyOrderedProgramGroups, int type) {
    DateTime now = DateTime.now();
    // GITHUB print('build week: ' + now.toString());
    DateTime temp = now.subtract(Duration(days: (now.weekday + 1) % 7));
    Map<String, int> spoutMap = {'خروجی ۱': 0, 'خروجی ۲': 1, 'خروجی ۱ و ۲': 2};
    Map<String, int> intervalMap = {
      "1 00:00:00": 0,
      "7 00:00:00": 1,
      "14 00:00:00": 2
    };
    DateTime firstOfWeek = DateTime(temp.year, temp.month, temp.day);
    //DateTime today = new DateTime(now.year, now.month, now.day);
    //print (firstOfWeek);
    Week week = Week();
    for (int j = 0; j < 7; j++) {
      week.days[j] = Day(
          number: j,
          date: firstOfWeek.add(Duration(days: j)),
          passed: (j < ((now.weekday + 1) % 7)),
          now: (j == ((now.weekday + 1) % 7)));
    }
    for (WeeklyOrderedProgramGroup e in weeklyOrderedProgramGroups!) {
      DateTime startFormatted =
          DateTime(e.start.year, e.start.month, e.start.day);
      var temp = startFormatted
          .difference(firstOfWeek)
          .inDays; //var temp = e.start.difference(firstOfWeek).inDays;
      var z = (temp >= 0) ? (temp ~/ 7) : (((temp + 1) ~/ 7) - 1).abs();
      DateTime lastProgramCancel =
          (e.lastProgramCancel != null) ? e.lastProgramCancel! : DateTime.now();
      if (e.interval == "1 00:00:00" && temp < 7) {
        if (temp >= 0 && (temp % 7) >= ((now.weekday + 1) % 7)) {
          week.days[temp % 7].programGroup.add(
            ProgramGroup(
              id: e.id,
              name: e.name,
              isOngoing: e.isOngoing,
              startTime: e.start,
              durationTime: DateTime.parse('0000-00-00 ' + e.programs[1].delay),
              interval: e.interval,
              intervalGroupValue: intervalMap[e.interval],
              spoutGroupValue: (type == 2) ? null : spoutMap[e.name],
              isCancelled: (e.lastProgramCancel == null)
                  ? false
                  : ((now.difference(lastProgramCancel).inDays < 1)
                      ? true
                      : false),
              //lastProgramCancel: e.lastProgramCancel,
              //programs: e.programs,
            ),
          );
        } else {
          //TODO what?
          week.days[((now.weekday + 1) % 7)].programGroup.add(
            ProgramGroup(
              id: e.id,
              name: e.name,
              isOngoing: e.isOngoing,
              startTime: e.start,
              durationTime: DateTime.parse('0000-00-00 ' + e.programs[1].delay),
              interval: e.interval,
              intervalGroupValue: intervalMap[e.interval],
              spoutGroupValue: (type == 2) ? null : spoutMap[e.name],
              isCancelled: (e.lastProgramCancel == null)
                  ? false
                  : ((now.difference(lastProgramCancel).inDays < 1)
                      ? true
                      : false),
              //lastProgramCancel: e.lastProgramCancel,
              //programs: e.programs,
            ),
          );
        }
      } else if (e.interval == "14 00:00:00") {
        week.days[temp % 7].programGroup.add(
          ProgramGroup(
            id: e.id,
            name: e.name,
            isOngoing: e.isOngoing,
            startTime: e.start,
            durationTime: DateTime.parse('0000-00-00 ' + e.programs[1].delay),
            interval: e.interval,
            intervalGroupValue: intervalMap[e.interval],
            spoutGroupValue: (type == 2) ? null : spoutMap[e.name],
            isInWeek: (z % 2 == 0),
            isCancelled: (e.lastProgramCancel == null)
                ? false
                : ((z % 2 == 0 && now.difference(lastProgramCancel).inDays < 13)
                    ? true
                    : false),
            //lastProgramCancel: e.lastProgramCancel,
            //programs: e.programs,
          ),
        );
      } else {
        week.days[temp % 7].programGroup.add(
          ProgramGroup(
            id: e.id,
            name: e.name,
            isOngoing: e.isOngoing,
            startTime: e.start,
            durationTime: DateTime.parse('0000-00-00 ' + e.programs[1].delay),
            interval: e.interval,
            intervalGroupValue: intervalMap[e.interval],
            spoutGroupValue: (type == 2) ? null : spoutMap[e.name],
            isCancelled: (e.lastProgramCancel == null)
                ? false
                : ((now.difference(lastProgramCancel).inDays < 6)
                    ? true
                    : false),
            //lastProgramCancel: e.lastProgramCancel,
            //programs: e.programs,
          ),
        );
      }
    }
    return week;
  }

  Future refreshDevice() async {
    //print("****");
    try {
      final HashModel hashModel = await getHash();
      if (isHashChanged(hashModel.hash)) _needRefresh = true;
    } catch (e) {
      // GITHUB print('Hash error');
      // GITHUB print(e);
    }
    if (_needRefresh) {
      try {
        model = await getDevice(model.id);
        for (int i = 0; i < buttonLoading.length; i++) {
          buttonLoading[i].isCancelled = false;
          buttonLoading[i].isStarted = false;
        }
        _needRefresh = false;
      } catch (e) {
        // GITHUB print('Refresh error');
        // GITHUB print(e);
      }
    }
  }

  Future addNewProgram(String? name, bool repeatable, int? intervalGroupValue,
      int? spoutGroupValue, DateTime startTime, DateTime duration) async {
    const String apiUrl =
        'http://baghyar.darkube.app/panel/api/u/program_group/';
    //final String backupUrl = 'http://37.152.181.206/panel/api/u/program_group/';
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:00');
    final DateFormat durationFormatter = DateFormat('HH:mm:00');
    final String startTimeFormatted = dateFormatter.format(startTime);
    final String durationFormatted = durationFormatter.format(duration);
    String interval = "1 00:00:00";
    Map<String, String> headers = {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json'
    };
    if (intervalGroupValue == 0) {
      interval = "1 00:00:00";
    } else if (intervalGroupValue == 1) {
      interval = "7 00:00:00";
    } else if (intervalGroupValue == 2) {
      interval = "14 00:00:00";
    }
    List<ProgramTemp> programs = [];
    List<ProgramSpout> spoutChanges = [];
    List<ProgramSpout> spoutChanges2 = [];
    if (model.typeNumber == 1 &&
        (spoutGroupValue == 2 || spoutGroupValue == 0)) {
      spoutChanges.add(ProgramSpout(
          id: model.spouts[0].id, spout: model.spouts[0].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[0].id, spout: model.spouts[0].id, isOn: false));
    }
    if ((model.typeNumber == 1 &&
            (spoutGroupValue == 2 || spoutGroupValue == 1)) ||
        model.typeNumber == 2) {
      spoutChanges.add(ProgramSpout(
          id: model.spouts[1].id, spout: model.spouts[1].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[1].id, spout: model.spouts[1].id, isOn: false));
    }
    if (model.typeNumber == 4 && spoutGroupValue == 0) {
      spoutChanges.add(ProgramSpout(
          id: model.spouts[0].id, spout: model.spouts[0].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[0].id, spout: model.spouts[0].id, isOn: false));
      spoutChanges.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: false));
    }
    if (model.typeNumber == 4 && spoutGroupValue == 1) {
      spoutChanges.add(ProgramSpout(
          id: model.spouts[1].id, spout: model.spouts[1].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[1].id, spout: model.spouts[1].id, isOn: false));
      spoutChanges.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: false));
    }
    if (model.typeNumber == 4 && spoutGroupValue == 2) {
      spoutChanges.add(ProgramSpout(
          id: model.spouts[2].id, spout: model.spouts[2].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[2].id, spout: model.spouts[2].id, isOn: false));
      spoutChanges.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: true));
      spoutChanges2.add(ProgramSpout(
          id: model.spouts[3].id, spout: model.spouts[3].id, isOn: false));
    }
    programs
        .add(ProgramTemp(number: 1, delay: "00:00:00", spouts: spoutChanges));
    programs.add(ProgramTemp(
        number: 2, delay: durationFormatted, spouts: spoutChanges2));
    final msg = jsonEncode(<String, dynamic>{
      "name": name,
      "device": model.id,
      "repeatable": true,
      "interval": interval,
      "start": startTimeFormatted,
      "programs": programs
    });
    // GITHUB print(msg);
    //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
    //server can not process the request
    // GITHUB print(response.body);
    if (response.statusCode == 200) {
      // GITHUB AddProgramModel addProgramModel = addProgramModelFromJson(
          // const Utf8Decoder().convert(response.bodyBytes));
      // GITHUB print(addProgramModel.isOngoing);
      try {
        await refreshDevice();
      } catch (e) {
        // GITHUB print(e);
      }
    } else {
      throw Exception('Failed!');
    }
  }

  Future deleteProgram(int id) async {
    final String apiUrl =
        'http://baghyar.darkube.app/panel/api/u/program_group/' +
            id.toString() +
            '/';
    // GITHUB print(apiUrl);
    Map<String, String> headers = {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json'
    };
    //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
    final response = await http.delete(Uri.parse(apiUrl), headers: headers);
    //print(Utf8Decoder().convert(response.bodyBytes));
    //server can not process the request
    if (response.statusCode == 200) {
      // GITHUB print(response.body);
      try {
        await refreshDevice();
      } catch (e) {
        // GITHUB print(e);
      }
    } else {
      // GITHUB print('Delete program error');
      throw Exception('Failed!');
    }
  }

  Future<HashModel> getHash() async {
    final String apiUrl =
        'http://baghyar.darkube.app/panel/api/u/device_hash/' +
            model.id.toString() +
            '/';
    //final String backupUrl = 'http://37.152.181.206/panel/api/u/VerifyUser/';
    Map<String, String> headers = {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json'
    };
    //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    //print(Utf8Decoder().convert(response.bodyBytes));
    //server can not process the request
    if (response.statusCode == 200) {
      return hashModelFromJson(
          const Utf8Decoder().convert(response.bodyBytes)); //response.body
    } else {
      throw Exception('Failed!');
    }
  }

  initialize(int type) async {
    int count = 2;
    // GITHUB print("type: " + type.toString());
    if (type == 3 || type == 4) count = 3;
    initialized = true;
    for (int i = 0; i < count; i++) {
      buttonLoading.add(LoadingIndicator(id: i));
    }
    // GITHUB print(count.toString() + " " + buttonLoading.length.toString());
  }

  focus() async {
    try {
      model = await getDevice(userDevice.id);
      isLoaded = true;
    } catch (e) {
      isLoaded = false;
      // GITHUB print(e);
    }
    isCurrent = true;
  }

  bool _needRefresh = false;
  bool isCurrent = false;
  bool isLoaded = false;
  bool isOngoing = false;
  String token;
  String hash = "WAIT";
  bool initialized = false;
  int firstOngoingProgramIndex = 0;
  DateTime startTaskTime = DateTime.now();
  DateTime endTaskTime = DateTime.now();
  Duration remainingTime = const Duration(hours: 1);
  late Week week;
  late DeviceModel model;
  UserDevicesModel userDevice;
  List<LoadingIndicator> buttonLoading = [];
}
