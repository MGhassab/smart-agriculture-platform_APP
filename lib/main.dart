import 'package:baghyar/presentation/pages/home.dart';
import 'package:baghyar/presentation/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'themes.dart';
//import 'check_serial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    const ProviderScope(
      child: BaghyarApp(),
    ),
  );
}

class BaghyarApp extends StatelessWidget {
  const BaghyarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
        //const Locale('en', 'US'), // American English
      ],
      locale: const Locale("fa", "IR"),
      title: 'Baghyar',
      themeMode: ThemeMode.system,
      //themeMode: ThemeMode.system,
      theme: BaghyarTheme.lightTheme,
      darkTheme: BaghyarTheme.darkTheme,
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const SignIn(),
      },
      //13131313
      //202120212021
      //32de7d4809463c103429ef181781a09bf4a8481e
      //home: CheckSerial(token: "9ca2a2448288cdb64ec283628f7fca36566fa8f0"),
      //home: CheckSerial(token: "a0ce81d2bc1819591435e11ffcf3757d6d13b391"),
    );
  }
}
