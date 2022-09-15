import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/accueil.dart';
import 'package:hackerearth_mtn_bj_2022/Views/historique.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String name = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List screens = [
    const Accueil(),
    const Historique()
  ];

  int _currentIndex = 0;

  void _initState() async {
    await FirebaseCore.instance.ensureInitialized();
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: AppColor.primaryColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home) , label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.history_edu) ,label: ''),
        ],
      ),
    );
  }
}