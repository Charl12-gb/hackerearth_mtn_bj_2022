import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/accueil.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

import 'components/components.dart';

class SousCompte extends StatelessWidget {
  const SousCompte({Key? key}) : super(key: key);
  // variables
  static String name = "/souscompte";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sous compte'),
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
                  "Crée un nouveau sous compte\n pour épargner",
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
  String? raison;
  String? minimumSold;
  String dropdownValue = '1 mois';
  var mois = [
    "1 mois",
    "3 mois",
    "6 mois",
    "1 ans",
  ];
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saisissez le nom du sous compte"),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "nom", // la raison
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sélectionner le type "),
            SizedBox(
              height: 8,
            ),
            DropdownButton(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: mois.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                }),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Montant minimal"),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              initialValue: "200",
              readOnly: true,
              decoration: InputDecoration(
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
            text: "soumettre",
            backgroundColor: AppColor.primaryColor)
      ]),
    );
  }
}
