import 'package:baghyar/helpers/secure_storage.dart';
import 'package:baghyar/presentation/pages/home.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SecureStorage.setToken('');
        //final SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('token', '');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
      child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/back.png'),
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          )),
    );
  }
}
