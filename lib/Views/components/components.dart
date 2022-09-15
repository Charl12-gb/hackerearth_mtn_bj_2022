import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/deposit_popup.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/extensions.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/utils.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';

class appButton extends StatelessWidget {
  const appButton({
    Key? key,
    required this.onPressed,
    this.text,
    required this.backgroundColor,
  }) : super(key: key);

  final text;
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
        child: Text(text, style: TextStyle(color: AppColor.textColor2),),
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
                      "Solde: ${account.balance}$devise",
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
                      child: const Text(
                        'Rétirer',
                        style: TextStyle(
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
                      child: const Text(
                        'Déposer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ) :const Text("Opération en cours...", style: TextStyle(fontSize: 12, color: Colors.orange),)
            ],
          )
        ],
      ),
    );
  }
}

class SousCompteLine extends StatelessWidget {
  const SousCompteLine({
    Key? key,
    required this.couleur,
    required this.text,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Color couleur;
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
              fontSize: 16, fontWeight: FontWeight.w700, color: couleur),
        ),
        ElevatedButton(
            onPressed: onPressed,
            child: Text("Ajouter"),
        ),
      ],
    );
  }
}

class roundedIcon extends StatelessWidget {
  const roundedIcon({
    Key? key,
    required this.couleur,
    required this.icon,
  }) : super(key: key);

  final Color couleur;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: Center(child: Icon(icon)),
      decoration: BoxDecoration(
          color: couleur, borderRadius: BorderRadius.circular(20)),
    );
  }
}

class TransactionBuilder extends StatelessWidget {
  const TransactionBuilder({
    Key? key, required this.transaction,
  }) : super(key: key);
  final Transaction transaction;

  String getTransInfo(){
    return transaction.metadata?["additionalInfo"]["payeeNote"]??"Dépôt Momo Epargne sur votre compte Momo Epargne";
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
                  transaction.type==TransactionType.deposit?"Dépôt":"Retrait",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: size.width*2/3,
                  child: Text(
                    getTransInfo(),
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
            borderSide: BorderSide(color: AppColor.primaryColor)
          );

class dotText extends StatelessWidget {
  const dotText({
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
        if (text2.length != 0) Text(text2)
      ],
    );
  }
}

BoxDecoration simpleDecoration({Color? colors, double? radius}) {
  return BoxDecoration(
      color: colors, borderRadius: BorderRadius.circular(radius!));
}
