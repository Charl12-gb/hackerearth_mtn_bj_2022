import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/firebase_core.dart';
import '../controllers/utils/pagination/paginate_firestore.dart';
import '../controllers/utils/utils.dart';
import '../models/models.dart' as models;

class Historique extends StatelessWidget {
  const Historique({Key? key}) : super(key: key);
  // variables
  static String name = "/historique";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.transactions, style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
        ),
        child: ConstrainedBox(constraints: BoxConstraints(minHeight: size.height-50),
          child: PaginateFirestore(
            physics: const BouncingScrollPhysics(),
            onEmpty: Center(child: Text(AppLocalizations.of(context)!.noTransactions)),
            itemBuilder: (context, documentSnapshots, index) {
              models.Transaction transaction = models.Transaction.fromMap(processSimpleDocument(documentSnapshots[index] as DocumentSnapshot<Map<String, dynamic>>));
              return  TransactionBuilder(transaction:transaction);
            },
            // orderBy is compulsory to enable pagination
            query: FirebaseCore.instance.getTransactionsQuery(),
            //Change types accordingly
            itemBuilderType: PaginateBuilderType.listView,
            // to fetch real-time data
            isLive: true,
            itemsPerPage: 2,
          ),
        ),
      ),
    );
  }
}

