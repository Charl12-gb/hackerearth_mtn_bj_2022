import 'package:flutter/widgets.dart';
import 'package:hackerearth_mtn_bj_2022/Views/accueil.dart';
import 'package:hackerearth_mtn_bj_2022/Views/historique.dart';
import 'package:hackerearth_mtn_bj_2022/Views/home.dart';
import 'package:hackerearth_mtn_bj_2022/Views/login.dart';
import 'package:hackerearth_mtn_bj_2022/Views/optScreen.dart';
import 'package:hackerearth_mtn_bj_2022/Views/newSousCompt.dart';
import 'package:hackerearth_mtn_bj_2022/Views/updateSousCompte.dart';
final Map<String, WidgetBuilder> Routes = {
  Login.name : (context) => const Login(),
  OPTScreen.name :(context) => const OPTScreen(),

  Home.name :(context) => const Home(),
  Accueil.name :(context) => const Accueil(),
  Historique.name :(context) => const Historique(),
  SousCompte.name : (context) => const SousCompte(),
  UpdateSousCompte.name : (context) => const UpdateSousCompte(),
};
