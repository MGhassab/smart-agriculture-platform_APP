import 'package:flutter/widgets.dart';

abstract class Styles {
  static const Color primaryColorLight = Color(0xff3f8169);
  static const Color primaryColorDark = Color(0xff00685b);
  static const Color secondaryColorLight = Color(0x28979797);
  static const Color secondaryColorDark = Color(0x28979797); //TODO FIX
  static const Color scaffoldBackgroundColorLight = Color(0xFFFFFFFF);
  static const Color scaffoldBackgroundColorDark = Color(0xFF131313); //TODO
  //static const Color cupertinoBackgroundColorLight = secondaryColorLight;
  //static const Color cupertinoBackgroundColorDark = scaffoldBackgroundColorDark;
  static const Color overlineColorLight = Color(0xff6d7278);
  static const Color overlineColorDark = Color(0xff6d7278); //FIX?
  static const Color subtitleColorLight = primaryColorLight; //TODO
  static const Color subtitleColorDark = primaryColorDark; //TODO
  static const Color processButtonColorLight = Color(0xffd8d8d8);
  static const Color processButtonColorDark = Color(0xffd8d8d8); //FIX
  static const Color antennaOffLight = processButtonColorLight;
  static const Color antennaOffDark = overlineColorLight;
  static const Color dayPassedColorLight = Color(0x1a000000); //FIX?
  static const Color dayPassedColorDark = Color(0xff1b1b1b); //TODO FIX
  static const Color dayNotPassedColorLight = Color(0xfff3f3f3);
  static const Color dayNotPassedColorDark = Color(0xff424242); //TODO FIX
  static const Color elevatedButtonColorLight = primaryColorLight;
  static const Color elevatedButtonColorDark = primaryColorDark;
  static const Color primaryTextColorLight = Color(0xffbbbbbb);
  static const Color primaryText2ColorLight = Color(0xff000000);
  static const Color secondaryTextColorLight = Color(0xFF282828); //TODO
  static const Color errorColor = Color(0xffe02020);
  static const Color primaryTextColorDark = Color(0xffbbbbbb);
  static const Color primaryText2ColorDark = Color(0xffffffff); //FIX?
  static const Color secondaryTextColorDark = Color(0xFF444444); //TODO
  static const Color hintColor = Color(0xff6d7278);
  static const Color textFieldBackgroundColorLight = Color(0xFFDCDCDC); //TODO
  static const Color textFieldBackgroundColorDark = Color(0xFF232323); //TODO
  static const Color bottomBarBackgroundColorLight = Color(0xFFFAFAFA); //TODO
  static const Color bottomBarBackgroundColorDark = Color(0xFF282828); //TODO
  static const List<List<AssetImage>> button = [
    [
      AssetImage('images/fingerprint.png'),
      AssetImage('images/abgiri.png'),
      AssetImage('images/1.png'),
      AssetImage('images/1.png')
    ],
    [
      AssetImage('images/fingerprint.png'),
      AssetImage('images/auto.png'),
      AssetImage('images/2.png'),
      AssetImage('images/2.png')
    ],
    [
      AssetImage('images/3.png'),
      AssetImage('images/3.png'),
      AssetImage('images/3.png'),
      AssetImage('images/3.png')
    ]
  ];
  //static const Color cardBackgroundColorLight = Color(0xFF282828); //TODO
  //static const Color cardBackgroundColorDark = Color(0xFFD7D7D7); //TODO
  static const double padding = 10;
  static const double buttonPadding = 15;
  static const double halfPadding = padding / 2;
  static const double buttonHeight = 60;
  static const double textFieldHeight = 50;
  static const double iconHeight = 120;
  static const double borderRadius = 10.0; //15
}

int getId(int i) {
  if (i < 1) return 0;
  return i - 1;
}
