import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/extensions.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';
import 'package:uiblock/uiblock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../colors.dart';
import '../../controllers/firebase_core.dart';
import 'components.dart';

class DepositPopup {

  static Future<void> requestDeposit(BuildContext context, Account account) async {
    double minimumSold = 200;
    final TextEditingController amountController = TextEditingController(text: "$minimumSold");

    Future<void> createTransaction() async {
      var amount = amountController.text;
      amount = amount.replaceAll("  ", " ");

      var d = double.tryParse(amount);
      if(d==null || d<minimumSold){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidAmount), behavior: SnackBarBehavior.floating,));
        return;
      }
      UIBlock.block(context);
      await FirebaseCore.instance.createTransaction(account: account, amount: d, type: TransactionType.deposit).then((value) async {
        UIBlock.unblock(context);
        await DepositPopup.handleTransactionStatus(context,{"transaction":value});
      }).onError((error, stackTrace){
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        UIBlock.unblock(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidAmount), behavior: SnackBarBehavior.floating,));
      });
    }

    await showDialog(
        context: context,
        builder: (context)=>StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(AppLocalizations.of(context)!.deposit, style: const TextStyle(fontSize: 20),),
              content: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.montantText),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          enabledBorder: outlineInputBorder,
                          focusedBorder: outlineInputBorder),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(AppLocalizations.of(context)!.requiredAmount(minimumSold.toString()), style: const TextStyle(fontSize: 10),),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                        onPressed: () {
                          createTransaction().whenComplete(() => Navigator.of(context).pop());
                        },
                        text: AppLocalizations.of(context)!.sendForm,
                        backgroundColor: AppColor.primaryColor
                    )
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  static Future<void> requestTransfer(BuildContext context, Account account) async {
    double available;
    bool applyPenalty = account.withdrawalDate > DateTime.now().millisecondsSinceEpoch;
    int penalty = 10;
    if(applyPenalty){
      available = account.balance -  (account.balance*penalty/100);
    }else{
      available = account.balance;
    }
    Future<void> createTransaction() async {
      UIBlock.block(context);
      await FirebaseCore.instance.createTransaction(account: account, amount: available, type: TransactionType.withdrawal).then((value) async {
        Future.delayed(const Duration(seconds: 10),() => FirebaseCore.instance.runTransactionsChecker());
        UIBlock.unblock(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pendingWithdrawalRequest), behavior: SnackBarBehavior.floating,));
      }).onError((error, stackTrace){
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        UIBlock.unblock(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorOccur), behavior: SnackBarBehavior.floating,));
      });
    }

    await showDialog(
        context: context,
        builder: (context)=>StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(AppLocalizations.of(context)!.wantToWithdrawal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              content: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.formattedBalance(account.balance.toString()),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      AppLocalizations.of(context)!.formattedPenalty(applyPenalty?penalty.toString():"0"),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.penaltyInfo(penalty.toString()),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      AppLocalizations.of(context)!.availableAmount(available.toString()),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                        onPressed: () {
                          createTransaction().whenComplete(() => Navigator.of(context).pop());
                        },
                        text: AppLocalizations.of(context)!.continueBtn,
                        backgroundColor: AppColor.primaryColor
                    )
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  static Future<TransactionStatus> handleTransactionStatus(BuildContext context, Map<String, dynamic> value) async {
    StreamSubscription<TransactionStatus> subscription = Stream.value(TransactionStatus.pending).listen((event) { });
    TransactionStatus transactionStatus = TransactionStatus.pending;
    bool i = false;
    await showDialog(context: context,
      builder: (context)=>StatefulBuilder(
        builder: (context, setState) {
          if(!i){
            subscription = FirebaseCore.instance.validateNewTransaction(transactionUuid:value["transaction"]["uuid"], transactionId: value["transaction"]["id"]).listen((event) async {
              if(event==TransactionStatus.pending){
              }else if(event==TransactionStatus.failed || event==TransactionStatus.rejected ||  event==TransactionStatus.timeout){
                subscription.cancel();
              }else if(event==TransactionStatus.successful){
                subscription.cancel();
                Future.delayed(const Duration(seconds: 1),() => Navigator.of(context).pop(context));
              }
              setState(() {
                transactionStatus = event;
              },);
            });
            i = true;
          }
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.awaitValidation,
              style: const TextStyle(fontSize: 15),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  transactionStatus==TransactionStatus.pending?const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )
                      :transactionStatusBuilder(color: transactionStatus.getColor(), iconData: transactionStatus.getIcon()),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(AppLocalizations.of(context)!.doNotExitApp, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            actions: const [],
          );
        },
      ),
    );

    subscription.cancel();
    return transactionStatus;
  }

  static Widget transactionStatusBuilder({required Color color, required IconData iconData, double size=60}){
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size/4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          // border: Border.all(color: color.withOpacity(0.18),width: 1),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: Icon(iconData, color: color, size: size/2),
      ),
    );
  }
}
