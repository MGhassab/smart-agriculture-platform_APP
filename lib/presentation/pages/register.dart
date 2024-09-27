import 'dart:async';
import 'dart:convert';

import 'package:baghyar/data/models/device_model.dart';
import 'package:baghyar/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  final String token;
  final String serial;

  const Register({Key? key, required this.token, required this.serial})
      : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
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

Future registerLand(
    String token, String land, String device, String serial) async {
  const String apiUrl =
      'http://baghyar.darkube.app/panel/api/u/register_land_and_device/';
  //final String backupUrl = 'http://37.152.181.206/panel/api/u/register_land_and_device/';
  Map<String, String> headers = {
    'Authorization': 'Token ' + token,
    'Content-Type': 'application/json'
  };
  final msg = jsonEncode(
      <String, String>{"serial": serial, "land": land, "device": device});
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

class _RegisterState extends State<Register> {
  final landNameController = TextEditingController();
  final deviceNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    landNameController.dispose();
    deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildLandName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 11,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              controller: landNameController,
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
                  hintText: 'عنوان باغ را وارد کنید'),
            ),
          ),
        ],
      );
    }

    Widget _buildRegisterText() {
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
                'لطفا اطلاعات این قسمت را با دقت وارد کنید تا از استفاده دستگاه لذت کافی را ببرید',
                style: Theme.of(context).textTheme.overline,
                //textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10.0),
          ]);
    }

    Widget _buildDeviceName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 11,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              controller: deviceNameController,
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
                  hintText: 'عنوان دستگاه را وارد کنید'),
            ),
          ),
        ],
      );
    }

    Widget _buildRegisterBtn() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            //print(deviceSNController.text);
            //checkName(deviceSNController.text);
            if (landNameController.text == "" ||
                deviceNameController.text == "") {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('اطلاعات به درستی وارد نشده است'),
                  );
                },
              );
            } else {
              try {
                //final DeviceModel deviceModel =
                await registerLand(widget.token, landNameController.text,
                    deviceNameController.text, widget.serial);
                /*final List<UserDevicesModel> userDevicesList = [
                  UserDevicesModel(id: deviceModel.id, name: deviceModel.name, typeNumber: deviceModel.typeNumber, land: deviceModel.land.name)
                ];*/
                final List<UserDevicesModel> userDevicesList =
                    await userDevices(widget.token);
                if (userDevicesList.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                            token: widget.token,
                            userDevicesList: userDevicesList)),
                  );
                }
                /*if (deviceModel.typeNumber == 1 || deviceModel.typeNumber == 2)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard(token: widget.token, userDevicesList: userDevicesList)),
                  );
                else
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
                //print(e);
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text('مشکلی پیش آمده است'),
                    );
                  },
                );
              }
            }
          },
          child: Text(
            'ثبت مشخصات',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      );
    }

    return Scaffold(
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
                    _buildRegisterText(),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/register.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildLandName(),
                    const SizedBox(height: 10.0),
                    _buildDeviceName(),
                    _buildRegisterBtn(),
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
