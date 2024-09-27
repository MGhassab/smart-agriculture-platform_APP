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
import 'dart:io' show Platform, exit;

import 'package:animations/animations.dart';
import 'package:baghyar/data/models/verify_request_model.dart';
import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'verify.dart';

//String _phoneNumber = "";

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
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

class _SignInState extends State<SignIn> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /*void checkPhone(String s) {
    setState(() {
      _counter++;
      if ((s.length == 11 && s.substring(0, 2) == "09") ||
          (s.length == 10 && s.substring(0, 1) == "9")) {
        _isValid = true;
        _phoneNumber = s;
      } else {
        _phoneNumber = "";
      }
    });
  }*/

  Widget _buildSignInText() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'خب بیا شروع کنیم',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          // Rectangle
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
              'ثبت نام در آبیاری هوشمند باغیار',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ]);
  }

  Widget _buildPhoneNumberTFF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 11,
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
                hintText: 'شماره همراه خود را وارد کنید'),
          ),
          /*TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 30.0),
              /*prefixIcon: Icon(
                Icons.phone,
                color: Colors.green,
              ),*/
            ),
            keyboardType:
          ),*/
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
            /* GITHUB final VerifyRequestModel verifyRequest =
                */
            await getVerification(myController.text);
            // GITHUB print(verifyRequest.expire);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verify(phoneNumber: myController.text)),
            );
          } catch (e) {
            //print(e);
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  //Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content: Text('شماره‌ی اشتباه'),
                );
              },
            );
          }
          //checkPhone();
        },
        child: Text(
          'ورود / ثبت نام',
          style: Theme.of(context).textTheme.button,
        ),
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
                            image: AssetImage('images/signin.png'),
                          ),
                        ),
                      ),
                      _buildSignInText(),
                      const SizedBox(height: 30.0),
                      _buildPhoneNumberTFF(),
                      _buildLoginBtn(),
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
