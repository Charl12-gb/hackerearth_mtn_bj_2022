import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackerearth_mtn_bj_2022/Views/login.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/routes.dart';

import 'Views/home.dart';
import 'Views/theme_provider.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  initializeDateFormatting("fr_FR", null).then((value) => Intl.defaultLocale = 'fr');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ThemeProvider _themeProvider = ThemeProvider();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momo Epargne',
      debugShowCheckedModeBanner: false,
      theme: _themeProvider.lightThemeData(),
      darkTheme: _themeProvider.darkThemeData(),
      themeMode: ThemeMode.system,
      initialRoute: FirebaseAuth.instance.currentUser!=null?Home.name:Login.name,  //OPTScreen.name,
      routes: Routes,
    );
  }
}

