import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles.dart';

class BaghyarTheme {
  static final darkTheme = ThemeData(
    /*pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),*/
    primarySwatch: Colors.green,
    //TODO
    primaryColor: Styles.primaryColorDark,
    hintColor: Styles.hintColor,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          secondary: Styles.secondaryColorDark,
        ),
    //TODO
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: Styles.primaryTextColorDark),
      titleTextStyle: TextStyle(color: Styles.primaryTextColorDark),
    ),
    //TODO
    applyElevationOverlayColor: true,
    //TODO
    scaffoldBackgroundColor: Styles.scaffoldBackgroundColorDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontSize: 1),
      unselectedLabelStyle: TextStyle(fontSize: 1),
      selectedItemColor: Styles.secondaryColorDark,
      type: BottomNavigationBarType.fixed,
      elevation: 3,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Styles.borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(Styles.buttonPadding),
        onPrimary: Styles.primaryTextColorDark,
        primary: Styles.elevatedButtonColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ).merge(
        ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 3;
              return 3;
            },
          ),
        ),
      ),
    ),
    inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
          filled: true,
          fillColor: Styles.textFieldBackgroundColorDark,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorDark, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorDark, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorDark, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(color: Styles.errorColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(color: Styles.errorColor, width: 2),
          ),
          errorStyle: const TextStyle(
            height: 0,
            color: Colors.transparent,
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Styles.primaryTextColorDark),
      //TODO FIX
    ),
    fontFamily: "IRANYekanWeb",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(
          fontSize: 18.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: Styles.primaryTextColorDark),
      //TODO FIX
      headline6: TextStyle(
          fontSize: 28.0,
          color: Styles.primaryTextColorDark,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700),
      bodyText1: TextStyle(
          fontSize: 18.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.primaryTextColorDark),
      bodyText2: TextStyle(
          fontSize: 20.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700,
          color: Styles.primaryText2ColorDark),
      overline: TextStyle(
          fontSize: 16.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.overlineColorDark),
      subtitle2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.subtitleColorDark),
      button: TextStyle(
          fontSize: 15.0, fontFamily: 'IRANYekanWeb', color: Colors.white),
      caption: TextStyle(fontSize: 14.0, fontFamily: 'IRANYekanWeb'),
    ),
  );

  static final lightTheme = ThemeData(
    /*pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),*/
    primarySwatch: Colors.green,
    //TODO
    primaryColor: Styles.primaryColorLight,
    hintColor: Styles.hintColor,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          secondary: Styles.secondaryColorLight,
        ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: Styles.primaryTextColorLight),
      titleTextStyle: TextStyle(color: Styles.primaryTextColorLight),
    ),
    scaffoldBackgroundColor: Styles.scaffoldBackgroundColorLight,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontSize: 1),
      unselectedLabelStyle: TextStyle(fontSize: 1),
      selectedItemColor: Styles.secondaryColorLight,
      type: BottomNavigationBarType.fixed,
      elevation: 3,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Styles.borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(Styles.buttonPadding),
        onPrimary: Styles.primaryTextColorLight,
        primary: Styles.elevatedButtonColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ).merge(
        ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 3;
              return 3;
            },
          ),
        ),
      ),
    ),
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
          filled: true,
          fillColor: Styles.textFieldBackgroundColorLight,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorLight, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorLight, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(
                color: Styles.textFieldBackgroundColorLight, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(color: Styles.errorColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Styles.borderRadius),
            borderSide: const BorderSide(color: Styles.errorColor, width: 2),
          ),
          errorStyle: const TextStyle(
            height: 0,
            color: Colors.transparent,
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Styles.primaryText2ColorLight), //TODO FIX
    ),
    fontFamily: "IRANYekanWeb",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(
          fontSize: 18.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: Styles.primaryText2ColorLight),
      //TODO FIX
      headline6: TextStyle(
          fontSize: 28.0,
          color: Styles.primaryText2ColorLight,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700),
      bodyText1: TextStyle(
          fontSize: 18.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.primaryTextColorLight),
      bodyText2: TextStyle(
          fontSize: 20.0,
          fontFamily: 'IRANYekanWeb',
          fontWeight: FontWeight.w700,
          color: Styles.primaryText2ColorLight),
      overline: TextStyle(
          fontSize: 16.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.overlineColorLight),
      subtitle2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'IRANYekanWeb',
          color: Styles.subtitleColorLight),
      button: TextStyle(
          fontSize: 15.0, fontFamily: 'IRANYekanWeb', color: Colors.white),
      caption: TextStyle(fontSize: 14.0, fontFamily: 'IRANYekanWeb'),
    ),
  );
}
