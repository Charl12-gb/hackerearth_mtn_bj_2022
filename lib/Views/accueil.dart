import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/new_sous_compte.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/firebase_core.dart';
import '../controllers/utils/pagination/paginate_firestore.dart';
import '../controllers/utils/utils.dart';
import 'components/components.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);
  // variables
  static String name = "/accueil";

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  String username = FirebaseCore.instance.currentUser?.name??"";
  double momoBalance = 0;
  int availableWithdraw = 0;
  String currency = 'CFA';

  void _initState() async {
    await FirebaseCore.instance.ensureInitialized();
    FirebaseCore.instance.runTransactionsChecker();
    username = FirebaseCore.instance.currentUser?.name??"";
    if(mounted){setState(() {},);}
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.myAccount, style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),),
        elevation: 0,
      ),
      body:Container(
        color: Colors.black.withOpacity(0.05),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: PaginateFirestore(
          physics: const BouncingScrollPhysics(),
          header: header(context),
          onEmpty: CustomScrollView(
            slivers: [header(context)],
          ),
          itemBuilder: (context, documentSnapshots, index) {
            Account account = Account.fromMap(processSimpleDocument(documentSnapshots[index] as DocumentSnapshot<Map<String, dynamic>>));
            return SousCompteItem(
              devise: " $currency",
              account: account,
            );
          },
          // orderBy is compulsory to enable pagination
          query: FirebaseCore.instance.getAccountsQuery(),
          //Change types accordingly
          itemBuilderType: PaginateBuilderType.listView,
          // to fetch real-time data
          isLive: true,
          itemsPerPage: 2,
        ),
      ),
    );
  }

  Widget header(BuildContext context){
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text(AppLocalizations.of(context)!.momoBalance, style: const TextStyle(fontSize: 15),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "***** ",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              Text(
                currency,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          BoardInfo(availableWithdraw: availableWithdraw, currency: currency,),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.yourAccount,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SousCompte.name);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:  AppColor.primaryColor,
                    ),
                    child: Text(AppLocalizations.of(context)!.add, style: const TextStyle(fontWeight: FontWeight.w500),),
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, SousCompte.name);
                //   },
                //   child: Text(AppLocalizations.of(context)!.add),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class BoardInfo extends StatelessWidget {
  const BoardInfo({
    Key? key, required this.availableWithdraw, required this.currency
  }) : super(key: key);

  final int availableWithdraw;
  final double totalBalance = 0;
  final String currency;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<Map<String, dynamic>>(
              stream: FirebaseCore.instance.getUserMomoEpagneBalance(),
              initialData: const {"balance":0, "availableWithdrawals":0},
              builder: (context, snapshot) {
                var totalBalance = snapshot.data?["balance"]??0;
                var availableWithdraw = snapshot.data?["availableWithdrawals"]??0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RoundedIcon(color: Colors.black.withOpacity(0.2), icon: Icons.account_balance_wallet),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.momoThriftBalance),
                            Text(
                              "$totalBalance $currency",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: simpleDecoration(
                        colors: availableWithdraw > 0 ? Colors.green.withAlpha(50) : Colors.red.withAlpha(50),
                        radius: 10,
                      ),
                      child: Text(AppLocalizations.of(context)!.availableWithdraw(availableWithdraw)),
                    )
                  ],
                );
              }),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("  Momo\nEpargne", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8,),),
          )
        ],
      ),
    );
  }
}
