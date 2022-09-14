import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/accueil.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

import 'components/components.dart';

class UpdateSousCompte extends StatelessWidget {
  const UpdateSousCompte({Key? key}) : super(key: key);
  // variables
  static String name = "/updatesouscompte";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Combien voulez vous déposer ? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SousCompteForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SousCompteForm extends StatefulWidget {
  const SousCompteForm({Key? key}) : super(key: key);

  @override
  State<SousCompteForm> createState() => _SousCompteFormState();
}

class _SousCompteFormState extends State<SousCompteForm> {
  final formKey = GlobalKey<FormState>();
  String? montant;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saisissez le montant"),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "montant", // la raison
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        appButton(
            onPressed: () {
              Navigator.pushNamed(context, Accueil.name);
            },
            text: "Confirmer",
            backgroundColor: AppColor.primaryColor)
      ]),
    );
  }
}
