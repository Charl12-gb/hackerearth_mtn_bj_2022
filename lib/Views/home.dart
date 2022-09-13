import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static String name = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Home"),
    );
  }
}