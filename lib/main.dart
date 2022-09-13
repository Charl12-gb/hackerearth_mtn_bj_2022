import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/login.dart';
import 'package:hackerearth_mtn_bj_2022/Views/optScreen.dart';
import 'package:hackerearth_mtn_bj_2022/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Login.name,  //OPTScreen.name,
      routes: Routes,
    );
  }
}

