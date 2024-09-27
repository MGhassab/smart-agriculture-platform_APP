import 'dart:async';
import 'dart:io' show Platform, exit;

import 'package:animations/animations.dart';

//import 'package:baghyar/data/models/CancelProgramModel.dart'; //TODO
import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/data/models/day.dart';
import 'package:baghyar/data/models/device.dart';
import 'package:baghyar/data/models/program_group.dart';
import 'package:baghyar/data/models/week.dart';
import 'package:baghyar/presentation/animations/three_bounce.dart';
import 'package:baghyar/presentation/widgets/add_device.dart';
import 'package:baghyar/presentation/widgets/back_button.dart';
import 'package:baghyar/presentation/widgets/device/device_frame.dart';
import 'package:baghyar/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

String getProgramName(int typeNumber, int spoutGroupValue) {
  Map<int, String> nameMap = {0: 'خروجی ۱', 1: 'خروجی ۲', 2: 'خروجی ۱ و ۲'};
  Map<int, String> nameMap2 = {0: 'شیفت ۱', 1: 'شیفت ۲', 2: 'شیفت ۳'};
  if (typeNumber == 1) return nameMap[spoutGroupValue] ?? '';
  if (typeNumber == 4) return nameMap2[spoutGroupValue] ?? '';
  return 'آبگیری'; //typeNumber == 2
}

Future cancelRunningProgram(String token, int id) async {
  //TODO <CancelProgramModel>
  final String apiUrl =
      'http://baghyar.darkube.app/panel/api/u/cancel_program_run/' +
          id.toString() +
          '/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/VerifyUser/';
  Map<String, String> headers = {
    'Authorization': 'Token ' + token,
    'Content-Type': 'application/json'
  };
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response = await http.post(Uri.parse(apiUrl), headers: headers);
  //print(Utf8Decoder().convert(response.bodyBytes));
  //server can not process the request
  if (response.statusCode == 200) {
    // GITHUB print('successfully stopped'); //return cancelProgramModelFromJson(Utf8Decoder().convert(response.bodyBytes)); //response.body
  } else {
    throw Exception('Failed!');
  }
}

class MyText extends StatelessWidget {
  //StatefulWidget
  const MyText({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        name,
        style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Shabnam',
            color: (Theme.of(context).brightness == Brightness.light)
                ? Styles.primaryText2ColorLight
                : Styles.primaryText2ColorDark),
      ),
    ); //?: (selected)?
  }
}

Map<int, String> weekMap = {
  0: 'شنبه',
  1: 'یکشنبه',
  2: 'دوشنبه',
  3: 'سه‌شنبه',
  4: 'چهارشنبه',
  5: 'پنج‌شنبه',
  6: 'جمعه'
};

String getWeekday(int i) {
  if (weekMap[i] == null) return 'روز اشتباه';
  return weekMap[i]!;
}

String getDateWeekday(DateTime date) {
  return getWeekday((date.weekday + 1) % 7);
}

class Dashboard extends StatefulWidget {
  final String token;
  final List<UserDevicesModel> userDevicesList;

  const Dashboard(
      {Key? key, required this.token, required this.userDevicesList})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  DateTime startTime = DateTime.now();
  DateTime durationTime = DateTime(0, 0, 0, 0, 10, 0, 0);

  //Duration duration2 = Duration(minutes: 0);
  bool errorOccurred = false;
  List<Device> device = [];
  int current = 0;

  bool switchState = false;
  int? spoutGroupValue = 0; //segmentedControlGroupValue
  int? intervalGroupValue = 0; //segmentedControl2GroupValue

  bool isOngoing = false;
  late AnimationController controller;
  Map<int, String> weekMap = {
    0: 'شنبه',
    1: 'یکشنبه',
    2: 'دوشنبه',
    3: 'سه‌شنبه',
    4: 'چهارشنبه',
    5: 'پنج‌شنبه',
    6: 'جمعه'
  };

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  initState() {
    if (mounted) super.initState();

    for (int i = 0; i < widget.userDevicesList.length; i++) {
      device.add(
          Device(userDevice: widget.userDevicesList[i], token: widget.token));
      device[i].initialize(widget.userDevicesList[i].typeNumber);
    }

    device[current].focus();
    startRefresher();
  }

  _onPageChanged(int index) {
    setState(() {
      device[current].isCurrent = false;
      current = index;
      device[current].focus();
    });
  }

  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.82);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void startRefresher() {
    Timer.periodic(
      const Duration(seconds: 1), //2
      (Timer timer) => setStateIfMounted(() {
        if (timer.tick % 2 == 0) device[current].refreshDevice(); //WRONG
        if (errorOccurred) {
          /*showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text('مشکلی پیش آمده است'),
                    );
                  },
                );*/
          errorOccurred = false;
        }
      } //WRONG
          ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showModal(
          configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 400),
            reverseTransitionDuration: Duration(milliseconds: 100),
          ),
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), //borderRadius: BorderRadius.circular(Styles.borderRadius),
            ),
            content: const Text('مایل به خروج از برنامه هستید؟'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      //style: ElevatedButton.styleFrom(
                      //shape: new RoundedRectangleBorder(
                      //  borderRadius: new BorderRadius.circular(Styles.borderRadius),
                      //),
                      //),
                      style: ElevatedButton.styleFrom(
                        //onPrimary: Colors.black87,
                        primary: Styles.errorColor, //Colors.blue[300],
                        minimumSize: const Size(88, 36),
                        //padding: EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(15.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        //elevation: 5.0,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('خیر'),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      //style: ElevatedButton.styleFrom(
                      //onPrimary: Colors.red, //onPrimary: Styles.errorColor,
                      //shape: new RoundedRectangleBorder(
                      //  borderRadius: new BorderRadius.circular(Styles.borderRadius),
                      //),
                      //),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                      child: const Text('بله'),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }

  /*void _printProgramGroups(List<ProgramGroup>? programGroup) {
    for (ProgramGroup e in programGroup!) {
      print(e.name);
      print(e.start);
    }
  }*/

  final Map<int, MyText> myTabs = <int, MyText>{
    //const <int...
    0: const MyText(name: 'خروجی ۱'),
    1: const MyText(name: 'خروجی ۲'),
    2: const MyText(name: 'خروجی ۱ و ۲'),
  };

  final Map<int, MyText> myShifts = <int, MyText>{
    //const <int...
    0: const MyText(name: 'شیفت ۱'),
    1: const MyText(name: 'شیفت ۲'),
    2: const MyText(name: 'شیفت ۳'),
  };

  final Map<int, MyText> myRepeats = <int, MyText>{
    //const <int...
    0: const MyText(name: 'هر روز'),
    1: const MyText(name: 'هر هفته'),
    2: const MyText(name: 'هر دو هفته')
  };

  Widget deviceProgramGroup(Device device) {
    DateTime now = DateTime.now();
    if (device.isLoaded) {
      if (device.model.firstOngoingProgram != null) {
        if (!device.isOngoing) {
          device.isOngoing = true;
          device.firstOngoingProgramIndex =
              device.model.firstOngoingProgram!.index;
          device.startTaskTime = DateTime(
              now.year,
              now.month,
              now.day,
              device
                  .model
                  .weeklyOrderedProgramGroups![device.firstOngoingProgramIndex]
                  .start
                  .hour,
              device
                  .model
                  .weeklyOrderedProgramGroups![device.firstOngoingProgramIndex]
                  .start
                  .minute,
              device
                  .model
                  .weeklyOrderedProgramGroups![device.firstOngoingProgramIndex]
                  .start
                  .second); //startTaskTime = device.weeklyOrderedProgramGroups![index].start;
          device.endTaskTime = device.startTaskTime.add(Duration(
              hours: int.parse(device
                  .model
                  .weeklyOrderedProgramGroups![device.firstOngoingProgramIndex]
                  .programs[1]
                  .delay
                  .substring(0, 2)),
              minutes: int.parse(device
                  .model
                  .weeklyOrderedProgramGroups![device.firstOngoingProgramIndex]
                  .programs[1]
                  .delay
                  .substring(3, 5))));
          device.remainingTime = device.endTaskTime.difference(now);
          // GITHUB print(device.startTaskTime.toString() +
              // '+' +
              // device.endTaskTime.toString());
        } else {
          device.remainingTime = device.endTaskTime.difference(now);
        }
      } else {
        device.isOngoing = false;
      }
    }
    if (!device.isLoaded) {
      final Week emptyWeek = getEmptyWeek();
      return Column(
        children: [
          const SizedBox(height: 10.0),
          _buildDay(emptyWeek.days[0]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[1]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[2]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[3]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[4]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[5]),
          const SizedBox(height: 6.0),
          _buildDay(emptyWeek.days[6]),
        ],
      );
    } else {
      return Column(
        children: [
          //if (device.isOngoing) SizedBox(height: 20.0),
          if (device.isOngoing)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //new Text(''),
                Text(
                  getDateWeekday(device.startTaskTime) +
                      ': برنامه ' +
                      device
                          .model
                          .weeklyOrderedProgramGroups![
                              device.model.firstOngoingProgram!.index]
                          .name +
                      ' در ' +
                      ((device.model.firstOngoingProgram!.hasSynced)
                          ? 'حال'
                          : 'انتظار') +
                      ' اجراست',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                if (device.model.firstOngoingProgram!.hasSynced)
                  Text(
                    ((device.remainingTime.inHours > 0)
                            ? ((device.remainingTime.inSeconds ~/ 3600)
                                    .toString() +
                                ':')
                            : '') +
                        ((device.remainingTime.inMinutes > 0)
                            ? (((device.remainingTime.inSeconds % 3600) ~/ 60)
                                    .toString() +
                                ':')
                            : '') +
                        (device.remainingTime.inSeconds % 60).toString(),
                    //device.weeklyOrderedProgramGroups![device.firstOngoingProgramIndex!].start
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
              ],
            ),
          const SizedBox(height: 10.0),
          _buildDay(device.week.days[0]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[1]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[2]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[3]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[4]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[5]),
          const SizedBox(height: 6.0),
          _buildDay(device.week.days[6]),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, //onWillPop: () async => false,
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          /*child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),*/
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/settings.png'),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  )),
                              Text(device[current].userDevice.land,
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center),
                              const MyBackButton(),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //new Text(''),
                            Text(
                              (widget.userDevicesList.length == 1)
                                  ? 'دستگاه'
                                  : 'دستگاه‌ها',
                              style: Theme.of(context).textTheme.overline,
                            ),
                            AddDevice(token: widget.token),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 285,
                        child: PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.userDevicesList.length,
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            return DeviceFrame(device: device[index]);
                          },
                        ),
                      ),
                      /*Row(
                        children: [
                          //new Text(''),
                          new Text(
                            'برنامه زمانی ',
                            style: Theme
                                .of(context)
                                .textTheme
                                .overline,
                          ),
                        ],
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: deviceProgramGroup(device[current]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateTime(DateTime newTime) {
    startTime = newTime;
    // GITHUB print(startTime);
  }

  void updateTask(ProgramGroup programGroup) {
    spoutGroupValue = programGroup.spoutGroupValue;
    intervalGroupValue = programGroup.intervalGroupValue;
  }

  Widget _buildStartTimePicker(DateTime start) {
    //=>
    updateTime(start);
    return SizedBox(
      height: 100,
      //width: 120,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              fontSize: 21, //21
              fontFamily: 'Shabnam',
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Styles.primaryText2ColorLight
                  : Styles.primaryText2ColorDark,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          initialDateTime: start,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
          onDateTimeChanged: (start) =>
              setStateIfMounted(() => startTime = start),
        ),
      ),
    );
  }

  Widget _buildDurationPicker(DateTime duration) => SizedBox(
        height: 100,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                fontSize: 21, //21
                fontFamily: 'Shabnam',
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Styles.primaryText2ColorLight
                    : Styles.primaryText2ColorDark,
              ),
            ),
          ),
          child: CupertinoDatePicker(
            initialDateTime: duration,
            mode: CupertinoDatePickerMode.time,
            minuteInterval: 5,
            use24hFormat: true,
            onDateTimeChanged: (duration) =>
                setStateIfMounted(() => durationTime = duration),
          ),
        ),
      );

  Widget _buildSheet(DateTime start, int type) => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //<Widget>
            Stack(
              //alignment: Alignment.topRight,
              children: <Widget>[
                //YourScrollViewWidget(),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 40,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    Navigator.pop(context);
                    //print(device.land.programGroups[0].start);
                  },
                )
              ],
            ),
            if (type == 1)
              Row(
                children: [
                  //new Text(''),
                  Text(
                    'انتخاب خروجی',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'IRANYekanWeb',
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Styles.overlineColorLight
                                : Styles.overlineColorDark), //WRONG
                  ),
                ],
              ),
            if (type == 4)
              Row(
                children: [
                  //new Text(''),
                  Text(
                    'انتخاب شیفت',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'IRANYekanWeb',
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Styles.overlineColorLight
                                : Styles.overlineColorDark), //WRONG
                  ),
                ],
              ),
            if (type == 1 || type == 4) const SizedBox(height: 8.0),
            if (type == 1)
              SizedBox(
                width: double.infinity,
                //height: 100,
                child: CupertinoSlidingSegmentedControl<int>(
                    thumbColor:
                        (Theme.of(context).brightness == Brightness.light)
                            ? Styles.primaryColorLight
                            : Styles.primaryColorDark,
                    //backgroundColor: (Theme.of(context).brightness == Brightness.light)?Styles.scaffoldBackgroundColorLight:Styles.scaffoldBackgroundColorDark,
                    groupValue: spoutGroupValue,
                    children: myTabs,
                    onValueChanged: (i) {
                      //print(myTabs[i]);
                      setStateIfMounted(() {
                        spoutGroupValue = i;
                      });
                    }),
              ),
            if (type == 4)
              SizedBox(
                width: double.infinity,
                //height: 100,
                child: CupertinoSlidingSegmentedControl<int>(
                    thumbColor:
                        (Theme.of(context).brightness == Brightness.light)
                            ? Styles.primaryColorLight
                            : Styles.primaryColorDark,
                    //backgroundColor: (Theme.of(context).brightness == Brightness.light)?Styles.scaffoldBackgroundColorLight:Styles.scaffoldBackgroundColorDark,
                    groupValue: spoutGroupValue,
                    children: myShifts,
                    onValueChanged: (i) {
                      //print(myTabs[i]);
                      setStateIfMounted(() {
                        spoutGroupValue = i;
                      });
                    }),
              ),
            if (type == 1 || type == 4) const SizedBox(height: 15.0),
            Row(
              children: [
                //new Text(''),
                Text(
                  'زمان شروع روند',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark), //WRONG
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: _buildStartTimePicker(start),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                //new Text(''),
                Text(
                  'تکرار',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark), //WRONG
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                  thumbColor: (Theme.of(context).brightness == Brightness.light)
                      ? Styles.primaryColorLight
                      : Styles.primaryColorDark,
                  //backgroundColor: (Theme.of(context).brightness == Brightness.light)?Styles.scaffoldBackgroundColorLight:Styles.scaffoldBackgroundColorDark,
                  groupValue: intervalGroupValue,
                  children: myRepeats,
                  onValueChanged: (i) {
                    setStateIfMounted(() {
                      intervalGroupValue = i;
                    });
                  }),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                //new Text(''),
                Text(
                  'مقدار زمان کارکرد',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark), //WRONG
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: _buildDurationPicker(durationTime),
            ),
            //SizedBox(height: 20.0),
            _buildAddProgramBtn(),
            //_buildCodeTFF(),
            //_buildLoginBtn(),
          ],
        ),
      );

  Widget _buildEditSheet(ProgramGroup task, int type) {
    //=>
    updateTask(task);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //<Widget>
          Stack(
            //alignment: Alignment.topRight,
            children: <Widget>[
              //YourScrollViewWidget(),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 40,
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  Navigator.pop(context);
                  //print(device.land.programGroups[0].start);
                },
              )
            ],
          ),
          if (type == 1)
            Row(
              children: [
                //new Text(''),
                Text(
                  'انتخاب خروجی',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark), //WRONG
                ),
              ],
            ),
          if (type == 1) const SizedBox(height: 8.0),
          if (type == 1)
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                  thumbColor: (Theme.of(context).brightness == Brightness.light)
                      ? Styles.primaryColorLight
                      : Styles.primaryColorDark,
                  //backgroundColor: (Theme.of(context).brightness == Brightness.light)?Styles.scaffoldBackgroundColorLight:Styles.scaffoldBackgroundColorDark,
                  groupValue: task.spoutGroupValue,
                  children: myTabs,
                  onValueChanged: (i) {
                    //print(myTabs[i]);
                    setStateIfMounted(() {
                      task.spoutGroupValue = i;
                      spoutGroupValue = i;
                    });
                  }),
            ),
          if (type == 1) const SizedBox(height: 15.0),
          Row(
            children: [
              //new Text(''),
              Text(
                'زمان شروع روند',
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'IRANYekanWeb',
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Styles.overlineColorLight
                        : Styles.overlineColorDark), //WRONG
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: _buildStartTimePicker(task.startTime),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              //new Text(''),
              Text(
                'تکرار',
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'IRANYekanWeb',
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Styles.overlineColorLight
                        : Styles.overlineColorDark), //WRONG
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<int>(
                thumbColor: (Theme.of(context).brightness == Brightness.light)
                    ? Styles.primaryColorLight
                    : Styles.primaryColorDark,
                //backgroundColor: (Theme.of(context).brightness == Brightness.light)?Styles.scaffoldBackgroundColorLight:Styles.scaffoldBackgroundColorDark,
                groupValue: task.intervalGroupValue,
                children: myRepeats,
                onValueChanged: (i) {
                  //print(myRepeats[i]);
                  setStateIfMounted(() {
                    task.intervalGroupValue = i;
                    intervalGroupValue = i;
                  });
                }),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              //new Text(''),
              Text(
                'مقدار زمان کارکرد',
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'IRANYekanWeb',
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Styles.overlineColorLight
                        : Styles.overlineColorDark), //WRONG
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: _buildDurationPicker(task.durationTime),
          ),
          const SizedBox(height: 10.0),
          _buildEditDeleteProgramBtn(task.id, true),
          _buildEditDeleteProgramBtn(task.id, false),
          //_buildCodeTFF(),
          //_buildLoginBtn(),
        ],
      ),
    );
  }

  Color programGroupColor(bool isInWeek, String interval, bool dayPassed) {
    //if (isCancelled) return (isInWeek)
    //? ((dayPassed && (interval == "14 00:00:00")) ? Colors.grey : Theme.of(context).primaryColor)
    //: (dayPassed)
    //? Theme.of(context).primaryColor
    //: Colors.grey;

    return (isInWeek)
        ? ((dayPassed && (interval == "14 00:00:00"))
            ? Colors.grey
            : Theme.of(context).primaryColor)
        : (dayPassed)
            ? Theme.of(context).primaryColor
            : Colors.grey;
  }

  List<Widget> _buildTasks(Day day) {
    List<Widget> widgets = [];
    for (int i = 0; i < day.programGroup.length; i++) {
      if (i < 2) {
        widgets.add(
          GestureDetector(
            onTap: () async {
              if (day.programGroup[i].isOngoing) {
                //final CancelProgramModel cancelProgramModel =
                Widget abortButton = TextButton(
                  child: Text(
                    "نه",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                Widget cancelButton = TextButton(
                  child: Text(
                    "بله!",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onPressed: () async {
                    try {
                      await cancelRunningProgram(
                          widget.token, day.programGroup[i].id);
                    } catch (e) {
                      // GITHUB print(e);
                    }
                    Navigator.of(context).pop();
                  },
                );
                AlertDialog alert = AlertDialog(
                  //title: Text("Notice"),
                  content: const Text(
                    "می‌خواهید برنامه‌ی زمانی را متوقف کنید؟",
                  ),
                  actions: [
                    abortButton,
                    cancelButton,
                  ],
                  insetPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0),
                  //titlePadding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
                //showAlertDialog(context);
                //print(cancelProgramModel.msg);
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  builder: (context) => _buildEditSheet(
                      day.programGroup[i], device[current].model.typeNumber),
                );
              }
            },
            child: Container(
              width: 100,
              height: 32,
              //20
              decoration: BoxDecoration(
                  /*border: Border.all(
                    width: 1.0,
                    color: (day.programGroup[i].isCancelled)
                        ? Styles.errorColor
                        : programGroupColor(day.programGroup[i].isInWeek, day.programGroup[i].interval, day.passed),
                  ),*/
                  borderRadius: const BorderRadius.all(Radius.circular(18.5)),
                  color: (day.programGroup[i].isCancelled && day.now)
                      ? Colors.grey
                      : programGroupColor(day.programGroup[i].isInWeek,
                          day.programGroup[i].interval, day.passed)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (day.programGroup[i].interval == "1 00:00:00" ||
                        day.programGroup[i].isOngoing)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: (day.programGroup[i].isOngoing)
                            ? (const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 10,
                              ))
                            : const Image(
                                image: AssetImage('images/repeat.png'),
                                //borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                      ),
                    //SizedBox(width:3.0),
                    Text(
                      day.programGroup[i].name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        widgets.add(const SizedBox(width: 5.0));
      }
    }
    if (day.programGroup.length < 2) {
      widgets.add(_buildPlusBtn(
          (day.passed) ? day.date.add(const Duration(days: 7)) : day.date));
    }
    return widgets;
  }

  Widget _buildDay(Day day) {
    String name = getWeekday(day.number);
    DateTime now = DateTime.now();
    DateTime temp =
        now.subtract(Duration(hours: now.hour, minutes: now.minute));
    return Column(
      /*height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0x1cffffff), width: 1),
          color: (day.passed)?const Color(0x1a000000):const Color(0xfff3f3f3)),*/
      children: <Widget>[
        SizedBox(
            height: 50,
            child: Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0x1cffffff), width: 1),
                  color: (day.passed)
                      ? ((Theme.of(context).brightness == Brightness.light)
                          ? Styles.dayPassedColorLight
                          : Styles.dayPassedColorDark)
                      : ((Theme.of(context).brightness == Brightness.light)
                          ? Styles.dayNotPassedColorLight
                          : Styles.dayNotPassedColorDark),
                ),
              ),
              if (day.now)
                FractionallySizedBox(
                  widthFactor: (device[current].isOngoing)
                      ? ((now
                                  .difference(device[current].startTaskTime)
                                  .inSeconds +
                              30) /
                          (device[current]
                                  .endTaskTime
                                  .difference(device[current].startTaskTime)
                                  .inSeconds +
                              30))
                      : ((now.difference(temp).inMinutes + 540) / (33 * 60)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: const Color(0x1cffffff), width: 1),
                      color: (device[current].isOngoing)
                          ? ((Theme.of(context).brightness == Brightness.dark)
                              ? const Color(0x801b1b1b)
                              : const Color(0x803f8169))
                          : ((Theme.of(context).brightness == Brightness.dark)
                              ? const Color(0x281b1b1b)
                              : const Color(
                                  0x283f8169)), //const Color(0x803f8169):const Color(0x283f8169),
                    ),
                    //color: Color(0x283f8169),
                  ),
                ),
              Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.overline,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      width: 1,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0x986d7278), width: 1))),
                  const SizedBox(width: 10.0),
                  //if (day.task[0].name!="NONE") SizedBox(width: 10.0),
                  /*if (day==null) SizedBox(width: 0.0) else*/
                  Row(
                    children: _buildTasks(day),
                  ),
                ],
              ),
            ])),
      ],
    );
  }

  Widget _buildPlusBtn(DateTime date) {
    return GestureDetector(
      onTap: () async {
        if (device[current].model.weeklyOrderedProgramGroups!.length < 15) {
          // GITHUB print("length: " +
              // device[current]
                 // .model
                 // .weeklyOrderedProgramGroups!
                 // .length
                 // .toString());
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
              builder: (context) =>
                  _buildSheet(date, device[current].model.typeNumber));
          //Navigator.of(context).pop();
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(
                    'در دستگاه فعلی قابلیت افزودن برنامه‌های بیشتر وجود ندارد'),
              );
            },
          );
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/add.png'),
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }

  Widget _buildAddProgramBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0), //10.0*2
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          //print(startTime);
          //print (startTimeFormatted); print (durationFormatted); print (spoutGroupValue); print (intervalGroupValue);
          try {
            await device[current].addNewProgram(
                getProgramName(
                    device[current].model.typeNumber, spoutGroupValue ?? 0),
                true,
                intervalGroupValue,
                spoutGroupValue,
                startTime,
                durationTime);
          } catch (e) {
            // GITHUB print(e);
          }
          Navigator.of(context).pop();
        },
        child: Text(
          'ثبت برنامه زمانی',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }

  Widget _buildEditDeleteProgramBtn(int id, bool editProgram) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0), //10.0*2
      width: double.infinity,
      child: ElevatedButton(
        style: (editProgram)
            ? ElevatedButton.styleFrom(
                //onPrimary: Colors.black87,
                primary: (Theme.of(context).brightness == Brightness.light)
                    ? Styles.primaryColorLight
                    : Styles.primaryColorDark, //Colors.blue[300],
                minimumSize: const Size(88, 36),
                //padding: EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(15.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //elevation: 5.0,
              )
            : ElevatedButton.styleFrom(
                //onPrimary: Colors.black87,
                primary: Styles.errorColor, //Colors.blue[300],
                minimumSize: const Size(88, 36),
                //padding: EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(15.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //elevation: 5.0,
              ),
        onPressed: () async {
          //print(startTime);
          //print (startTimeFormatted); print (durationFormatted); print (spoutGroupValue); print (intervalGroupValue);
          try {
            device[current].deleteProgram(id);
          } catch (e) {
            // GITHUB print(e);
          }
          if (editProgram) {
            try {
              await device[current].addNewProgram(
                  getProgramName(
                      device[current].model.typeNumber, spoutGroupValue ?? 0),
                  true,
                  intervalGroupValue,
                  spoutGroupValue,
                  startTime,
                  durationTime);
            } catch (e) {
              // GITHUB print(e);
              // GITHUB print('injaaa');
            }
          }
          Navigator.of(context).pop();
        },
        child: Text(
          (editProgram) ? 'تغییر برنامه زمانی' : 'حذف برنامه زمانی',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
