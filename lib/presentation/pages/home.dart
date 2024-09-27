/*import 'package:flutter/material.dart';
import 'verify.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
//import 'dart:async';
//import 'dart:io';
//import 'package:imei_plugin/imei_plugin.dart';
//import 'package:wifi_info_plugin/wifi_info_plugin.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('images/signin.jpg'),
              ),
            ),
          ),
          Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(100)
                  ),
                  color: const Color(0xff3f8169)
              )
          ),
          // Rectangle 11
          Container(
              width: 327,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                  border: Border.all(
                      color: const Color(0x28979797),
                      width: 1
                  ),
                  color: const Color(0xfff7f7f7)
              )
          ),
          // Rectangle 11
          Container(
              width: 327,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                  color: const Color(0xff3f8169)
              )
          )
        ],
      )
      );
  }
}*/

import 'dart:async';
import 'dart:convert';

import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/data/models/verify_request_model.dart';
import 'package:baghyar/helpers/secure_storage.dart';
import 'package:baghyar/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'check_serial.dart';
import 'signin.dart';

//String _phoneNumber = "";

class Home extends StatefulWidget {
  final bool testing;

  const Home({Key? key, this.testing = false}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
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

Future<VerifyRequestModel> getVerification(String phone) async {
  const String apiUrl =
      'http://baghyar.darkube.app/panel/api/u/GetVerification_v2/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/GetVerification/';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final msg = jsonEncode(<String, String>{"username": phone});
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
  //server can not process the request
  if (response.statusCode == 200) {
    return verifyRequestModelFromJson(
        const Utf8Decoder().convert(response.bodyBytes)); //response.body()
  } else {
    throw Exception('Failed!');
  }
}

class _HomeState extends State<Home> {
  late String token;

  @override
  void initState() {
    loginUser();
    super.initState();
  }

  Future fetchData() async {
    token = await SecureStorage.getToken();
  }

  Future loginUser() async {
    await fetchData();
    if (widget.testing) {
      SecureStorage.setToken('9ca2a2448288cdb64ec283628f7fca36566fa8f0');
    }
    if (token != '') {
      try {
        final List<UserDevicesModel> userDevicesList = await userDevices(token);
        if (userDevicesList.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Dashboard(token: token, userDevicesList: userDevicesList)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckSerial(token: token)),
          );
        }
        /*
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text('برنامه از دستگاه شما پشتیبانی نمی‌کند'),
              );
            },
          );*/
      } catch (e) {
        SecureStorage.setToken('');
        // GITHUB print(e);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SizedBox(width: 10.0),
      ),
    );
  }
}
