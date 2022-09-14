import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';

class Historique extends StatelessWidget {
  const Historique({Key? key}) : super(key: key);
  // variables
  static String name = "/historique";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            transactionInfo(
              headLine: "Requêtte de dépot",
              message: "Vous avez éfectué un dépôt avec succèss sur votre sous compte (Achât de moto)",
              date: "01/09/2022",
              icon: Icons.priority_high,
            ),
            transactionInfo(
              headLine: "Requêtte de dépot",
              message: "Vous avez éfectué un dépôt avec succèss sur votre sous compte (Achât de moto)",
              date: "01/09/2022",
              icon: Icons.abc_rounded,
            ),
            transactionInfo(
              headLine: "Requêtte de dépot",
              message: "Vous avez éfectué un dépôt avec succèss sur votre sous compte (Achât de moto)",
              date: "01/09/2022",
              icon: Icons.abc_rounded,
            ),
            transactionInfo(
              headLine: "Requêtte de dépot",
              message: "Vous avez éfectué un dépôt avec succèss sur votre sous compte (Achât de moto)",
              date: "01/09/2022",
              icon: Icons.abc_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

