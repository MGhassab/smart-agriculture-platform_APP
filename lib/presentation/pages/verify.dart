import 'dart:async';
import 'dart:convert';

import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/data/models/verify_model.dart';
import 'package:baghyar/helpers/secure_storage.dart';
import 'package:pushe_flutter/pushe.dart';
import 'package:baghyar/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'check_serial.dart';

class Verify extends StatefulWidget {
  final String phoneNumber;

  const Verify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

Future<VerifyModel> verifyUser(String phone, String code) async {
  const String apiUrl = 'http://baghyar.darkube.app/panel/api/u/VerifyUser_v2/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/VerifyUser/';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final msg = jsonEncode(<String, String>{"username": phone, "code": code});
  //final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: {"username": phone});
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: msg);
  //server can not process the request
  if (response.statusCode == 200) {
    return verifyModelFromJson(
        const Utf8Decoder().convert(response.bodyBytes)); //response.body
  } else {
    throw Exception('Failed!');
  }
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

class _VerifyState extends State<Verify> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget _buildVerifyText() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'تأیید هویت',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5.0),
          Center(
            child: Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              'یک پیام خوش‌آمد میاد برات که توش یه کد هست، واردش کن',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ]);
  }

  Widget _buildCodeTFF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 5,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            // Only numbers can be entered
            controller: myController,
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
                hintText: 'کد تأیید'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            final VerifyModel verifyModel =
                await verifyUser(widget.phoneNumber, myController.text);
            //final SharedPreferences prefs = await SharedPreferences.getInstance();
            //prefs.setString('token', verifyModel.token);
            Pushe.setUserPhoneNumber(widget.phoneNumber);
            SecureStorage.setToken(verifyModel.token);
            final List<UserDevicesModel> userDevicesList =
                await userDevices(verifyModel.token);
            if (userDevicesList.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                        token: verifyModel.token,
                        userDevicesList: userDevicesList)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CheckSerial(token: verifyModel.token)),
              );
            }
          } catch (e) {
            //print(e);
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  // Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content: Text('کد اشتباه'),
                );
              },
            );
          }
        },
        child: Text(
          'ورود / ثبت نام',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: 30.0),
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/verify.png'),
                        ),
                      ),
                    ),
                    _buildVerifyText(),
                    const SizedBox(height: 30.0),
                    _buildCodeTFF(),
                    _buildLoginBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      //),
    );
  }
}
