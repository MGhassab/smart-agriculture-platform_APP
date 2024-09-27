import 'package:baghyar/presentation/pages/check_serial.dart';
import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';

class AddDevice extends StatelessWidget {
  final String token;

  const AddDevice({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //padding: EdgeInsets.symmetric(vertical: 20.0), //10.0*2
      width: 32,
      child: IconButton(
        icon: const Icon(Icons.add),
        iconSize: 20,
        color: (Theme.of(context).brightness == Brightness.light)
            ? Styles.overlineColorLight
            : Styles.overlineColorDark,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckSerial(token: token, canReturn: true)),
          );
        },
        /*width: 32,
          height: 32,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/add.png'),
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),*/
      ),
    );
  }
}
