import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/newSousCompt.dart';
import 'package:hackerearth_mtn_bj_2022/Views/updateSousCompte.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

import 'components/components.dart';

class Accueil extends StatelessWidget {
  const Accueil({Key? key}) : super(key: key);
  // variables
  static String name = "/accueil";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon compte'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text("Luc Changodina"),
              Text(
                "450.000 CFA",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              SizedBox(
                height: 25,
              ),
              BoardInfo(retraitDispo: 1),
              SizedBox(
                height: 25,
              ),
              sousCompteLine(
                text: "Sous compte",
                couleur: AppColor.primaryColor,
                icon: Icons.add_circle_outline,
                onPressed: () {
                  Navigator.pushNamed(context, SousCompte.name);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  SousCompteItem(
                    raison: "Contribution des enfants",
                    sold: "250.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: true,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                  SousCompteItem(
                    raison: "Achât de moto",
                    sold: "150.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: false,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                  SousCompteItem(
                    raison: "Assurance maladie",
                    sold: "50.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: false,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                  SousCompteItem(
                    raison: "Contribution des enfants",
                    sold: "250.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: false,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                  SousCompteItem(
                    raison: "Achât de moto",
                    sold: "150.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: false,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                  SousCompteItem(
                    raison: "Assurance maladie",
                    sold: "50.000",
                    devise: "CFA",
                    date: "05/11/2022",
                    aviable: false,
                    retirer: () {},
                    deposer: () {
                      Navigator.pushNamed(context, UpdateSousCompte.name);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BoardInfo extends StatelessWidget {
  const BoardInfo({
    Key? key, required this.retraitDispo,
  }) : super(key: key);

  final int retraitDispo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40 * 3,
      width: double.infinity,
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 30),
        padding: EdgeInsets.all(14),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      roundedIcon(
                          couleur: AppColor.gray, icon: Icons.account_balance_wallet),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Solde Mobile Money"),
                          Text(
                            "5000 CFA",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Text(" ${retraitDispo.toString().length<=1? "0${retraitDispo}" : retraitDispo} retrait disponible"),
                    decoration: simpleDecoration(
                        colors: retraitDispo > 0
                            ? Colors.green.withAlpha(50)
                            : Colors.red.withAlpha(50),
                        radius: 10),
                  )
                ],
              ),
              Column(
                children: [
                  dotText(
                      dotColor: Colors.green,
                      text: "Dernier dépot",
                      text2: "4500 CFA"),
                  SizedBox(
                    height: 13,
                  ),
                  dotText(
                      dotColor: Colors.red,
                      text: "Dernier retrait",
                      text2: "50.000 CFA"),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 228, 228, 228),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(0, 2))
          ],
        ),
      ),
    );
  }
}
