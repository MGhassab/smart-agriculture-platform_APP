import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, exit;

import 'package:animations/animations.dart';
import 'package:baghyar/data/models/check_serial_model.dart';
import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/presentation/pages/dashboard.dart';
import 'package:baghyar/presentation/pages/register.dart';
import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CheckSerial extends StatefulWidget {
  final String token;
  final bool canReturn;

  const CheckSerial({Key? key, required this.token, this.canReturn = false})
      : super(key: key);

  @override
  _CheckSerialState createState() => _CheckSerialState();
}

Future<List<UserDevicesModel>> userDevices(String token) async {
  const String apiUrl = 'http://baghyar.darkube.app/panel/api/u/user_devices/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/VerifyUser/';
  Map<String, String> headers = {
    'Authorization': 'Token ' + token,
    'Content-Type': 'application/json'
  };
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response = await http.get(Uri.parse(apiUrl), headers: headers);
  //server can not process the request
  if (response.statusCode == 200) {
    return userDevicesModelFromJson(
        const Utf8Decoder().convert(response.bodyBytes)); //response.body
  } else {
    throw Exception('Failed!');
  }
}

Future<CheckSerialModel> checkDeviceSN(String token, String serial) async {
  const String apiUrl =
      'http://baghyar.darkube.app/panel/api/u/serial_available/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/serial_available/';
  Map<String, String> headers = {
    'Authorization': 'Token ' + token,
    'Content-Type': 'application/json'
  };
  final msg = jsonEncode(<String, String>{"serial": serial});
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
  //server can not process the request
  if (response.statusCode == 200) {
    return checkSerialModelFromJson(
        const Utf8Decoder().convert(response.bodyBytes));
  } else {
    throw Exception('Failed!');
  }
}

Future registerLand(String token, String serial) async {
  const String apiUrl =
      'baghyar.darkube.app/panel/api/u/register_land_and_device/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/register_land_and_device/';
  Map<String, String> headers = {
    'Authorization': 'Token ' + token,
    'Content-Type': 'application/json'
  };
  final msg = jsonEncode(<String, String>{"serial": serial});
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
  //server can not process the request
  if (response.statusCode == 200) {
    //return deviceFromJson(Utf8Decoder().convert(response.bodyBytes)); //TODO
  } else {
    throw Exception('Failed!');
  }
}

class _CheckSerialState extends State<CheckSerial> {
  final deviceSNController = TextEditingController();
  DateTime startTime = DateTime.now();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    deviceSNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDeviceSN() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 12,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              controller: deviceSNController,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x28979797),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x28979797),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'شماره سریال دستگاه را وارد کنید',
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildCheckSerialText() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50.0),
            /*Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                //YourScrollViewWidget(),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 30,
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),*/
            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //new Text(''),
                Text(
                  'ثبت مشخصات',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                'لطفا اطلاعات این قسمت را با دقت وارد کنید تا در استفاده از دستگاه لذت کافی را ببرید',
                style: Theme.of(context).textTheme.overline,
                //textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10.0),
          ]);
    }

    Widget _helpMe() {
      return Center(
        child: InkWell(
            child: Text('شماره سریال ندارم، چطور بگیرم؟',
                style: Theme.of(context).textTheme.subtitle2),
            onTap: () => launch('http://ldm.co.ir')),
      );
    }

    Future<bool> _onWillPop() async {
      if (widget.canReturn) {
        return Future.value(true);
      } else {
        await showModal(
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
        );
      }
      return Future.value(false);
    }

    Widget _buildCheckSerialBtn() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            // GITHUB print(deviceSNController.text);
            // GITHUB print(startTime);
            //checkName(deviceSNController.text);
            try {
              final CheckSerialModel checkSerialModel =
                  await checkDeviceSN(widget.token, deviceSNController.text);
              if (checkSerialModel.hasLand) {
                //final DeviceModel deviceModel =
                await registerLand(widget.token, deviceSNController.text);
                /*final List<UserDevicesModel> userDevicesList = [
                  UserDevicesModel(id: deviceModel.id, name: deviceModel.name, typeNumber: deviceModel.typeNumber, land: deviceModel.land.name)
                ];*/
                final List<UserDevicesModel> userDevicesList =
                    await userDevices(widget.token);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(
                          token: widget.token,
                          userDevicesList: userDevicesList)),
                );
                /*if (deviceModel.typeNumber==1 || deviceModel.typeNumber==2) Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(token: widget.token, userDevicesList: userDevicesList)),);
                else showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text('برنامه از دستگاه شما پشتیبانی نمی‌کند'),
                      );
                    },
                  );*/
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Register(
                          token: widget.token,
                          serial: deviceSNController.text)),
                );
              }
            } catch (e) {
              // GITHUB print(e);
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('سریال نامعتبر'),
                  );
                },
              );
            }
          },
          child: Text(
            'ثبت سریال',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        /*appBar: AppBar(
          title: Text("Sign Up"),
        ),*/
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildCheckSerialText(),
                      const SizedBox(height: 40.0),
                      Container(
                        height: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/serial.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      _buildDeviceSN(),
                      const SizedBox(height: 10.0),
                      _helpMe(),
                      _buildCheckSerialBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        //),
      ),
    );
  }
}
