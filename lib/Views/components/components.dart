import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/deposit_popup.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/extensions.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/utils.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)), // foreground
            backgroundColor: backgroundColor), //AppColor.primaryColor
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: AppColor.textColor2),),
      ),
    );
  }
}

class SousCompteItem extends StatelessWidget {
  const SousCompteItem({
    Key? key,
    required this.devise,
    required this.account,
  }) : super(key: key);
  final String devise;
  final Account account;

  @override
  Widget build(BuildContext context) {
    bool available = account.withdrawalDate <= DateTime.now().millisecondsSinceEpoch;

    bool isFreezeAccount = account.metadata?["freezeAccount"]??false;

    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width/2 - 30,
                child: Text(account.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              InkWell(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            title: Text( AppLocalizations.of(context)!.description),
                            content: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Text(account.description),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(AppLocalizations.of(context)!.close)),
                            ],
                          );
                        },);
                      });
                },
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.info_outline, size: 18),
                ),
              ),
              SizedBox(
                // width: size.width/2,
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                      size: 16,
                    ),
                    Text(
                      formattedDateTime(DateTime.fromMillisecondsSinceEpoch(account.withdrawalDate)),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: isFreezeAccount?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
            children: [
              if(!isFreezeAccount)SizedBox(
                // width: size.width/2 - 30,
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.formattedBalance(account.balance.toString()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              !isFreezeAccount?
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      DepositPopup.requestTransfer(context, account);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration:
                          simpleDecoration(colors: available? Colors.green : Colors.red, radius: 4),
                      child: Text(
                        AppLocalizations.of(context)!.withdrawalBtn,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: (){
                      DepositPopup.requestDeposit(context, account);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration:
                          simpleDecoration(colors: Colors.blue, radius: 4),
                      child: Text(
                        AppLocalizations.of(context)!.depositBtn,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ) :Text(AppLocalizations.of(context)!.operationInProgress, style: const TextStyle(fontSize: 12, color: Colors.orange),)
            ],
          ),
        ],
      ),
    );
  }
}

class SousCompteLine extends StatelessWidget {
  const SousCompteLine({
    Key? key,
    required this.color,
    required this.text,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final String text;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: color),
        ),
        ElevatedButton(
            onPressed: onPressed,
            child: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }
}

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    Key? key,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
      child: Center(child: Icon(icon)),
    );
  }
}

class TransactionBuilder extends StatelessWidget {
  const TransactionBuilder({
    Key? key, required this.transaction,
  }) : super(key: key);
  final Transaction transaction;

  String getTransInfo(BuildContext context){
    if(transaction.type==TransactionType.withdrawal){
      return AppLocalizations.of(context)!.withdrawalPayerNote(transaction.metadata?["additionalInfo"]["payeeNote"], transaction.amount.toString());
    }else {
      return AppLocalizations.of(context)!.depositPayeeNote(transaction.metadata?["additionalInfo"]["payeeNote"]);
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DepositPopup.transactionStatusBuilder(color: transaction.status.getColor(), iconData: transaction.status.getIcon(),size: 40),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type==TransactionType.deposit?AppLocalizations.of(context)!.deposit:AppLocalizations.of(context)!.withdrawalBtn,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: size.width*2/3,
                  child: Text(
                    getTransInfo(context),
                    maxLines: 3,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               formattedDateTime(DateTime.fromMillisecondsSinceEpoch(transaction.createdAt)),
               style: TextStyle(
                   fontSize: 10,
                   color: Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.8),
                   fontWeight: FontWeight.w700),
             ),
             const SizedBox(height: 10,),
             Text(
               transaction.type==TransactionType.deposit?'+${transaction.amount} CFA':'-${transaction.amount} CFA',
               overflow: TextOverflow.ellipsis,
               style: const TextStyle(
                   fontSize: 14,
                   // color: transaction.status.getColor(),
                   fontWeight: FontWeight.w700
               ),
             ),
             Text(
               transaction.status.toIntl(),
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                   fontSize: 10,
                   color: transaction.status.getColor(),
                   fontWeight: FontWeight.w700
               ),
             ),
           ],
         )
        ],
      ),
    );
  }
}

var outlineInputBorder = OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            gapPadding: 15,
            borderSide: const BorderSide(color: AppColor.primaryColor)
          );

class DotText extends StatelessWidget {
  const DotText({
    Key? key,
    required this.dotColor,
    required this.text,
    this.text2 = '',
  }) : super(key: key);
  final Color dotColor;
  final String text;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: dotColor,
            ),
            Text(text)
          ],
        ),
        if (text2.isNotEmpty) Text(text2)
      ],
    );
  }
}

BoxDecoration simpleDecoration({Color? colors, double? radius}) {
  return BoxDecoration(
      color: colors, borderRadius: BorderRadius.circular(radius!));
}
