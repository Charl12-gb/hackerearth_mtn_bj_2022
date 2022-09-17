import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/firebase_core.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uiblock/uiblock.dart';

import '../models/enums.dart';
import 'components/components.dart';
import 'components/deposit_popup.dart';

class SousCompte extends StatelessWidget {
  const SousCompte({Key? key}) : super(key: key);
  // variables
  static String name = "/souscompte";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.compteBeforeName, style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height-50),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.msgCreateCompte,
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
  double minimumSold = 200;
  ThriftDate thriftDate = ThriftDate.oneMonth;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();


  @override
  void initState() {
    _amountController.text = minimumSold.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.inputText),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              maxLength: 25,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.placeName, // la raison
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Description"),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "Description", // la raison
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.dateText),
            const SizedBox(
              height: 8,
            ),
            DropdownButton<ThriftDate>(
                value: thriftDate,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ThriftDate.values.map((ThriftDate items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items.toIntl()),
                  );
                }).toList(),
                onChanged: (ThriftDate? value) {
                  setState(() {
                    thriftDate = value!;
                  });
                }),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.montantText),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(AppLocalizations.of(context)!.amountDesc(200), style: const TextStyle(fontSize: 10),),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        appButton(
            onPressed: () {
              createSousCompte();
            },
            text: AppLocalizations.of(context)!.btnText,
            backgroundColor: AppColor.primaryColor)
      ]),
    );
  }

  Future<void> createSousCompte() async {
    //Validation
    var name = _nameController.text;
    name = name.replaceAll("  ", " ");

    var amount = _amountController.text;
    amount = amount.replaceAll("  ", " ");

    var description = _descriptionController.text;
    description = description.replaceAll("  ", " ");

    if(name.trim().isEmpty || amount.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fieldAlert), behavior: SnackBarBehavior.floating,));
      return;
    }
    var d = double.tryParse(amount);
    if(d==null || d<minimumSold){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.amountError), behavior: SnackBarBehavior.floating,));
      return;
    }

    UIBlock.block(context);
    await FirebaseCore.instance.createAccount(name: name, description: description, withdrawalDate: thriftDate.toDateTime(), amount: d, onTransactionCreated: (bool created) {

    }).then((value) async {
      UIBlock.unblock(context);
      var s = await DepositPopup.handleTransactionStatus(context,value);
      if(s!=TransactionStatus.successful)return;
      await Future(() => Navigator.of(context).pop());
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      UIBlock.unblock(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorMsg), behavior: SnackBarBehavior.floating,));
      return null;
    });
  }
}
