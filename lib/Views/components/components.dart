import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

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
        child: Text(
          text,
          style: TextStyle(color: AppColor.textColor2),
        ),
      ),
    );
  }
}

class SousCompteItem extends StatelessWidget {
  const SousCompteItem({
    Key? key,
    required this.raison,
    required this.sold,
    required this.date,
    this.retirer,
    this.deposer,
    required this.devise, required this.aviable,
  }) : super(key: key);
  final String raison;
  final String sold;
  final String devise;
  final String date;
  final bool aviable;
  final void Function()? retirer;
  final void Function()? deposer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(raison),
              Row(
                children: [
                  Text("Déposé :"),
                  Text(
                    sold + devise,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                    size: 16,
                  ),
                  Text(
                    'Date de retrait: ${date}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: retirer,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Rétirer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                      decoration:
                          simpleDecoration(colors: aviable? Colors.green : Colors.red, radius: 4),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: deposer,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Déposer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                      decoration:
                          simpleDecoration(colors: Colors.blue, radius: 4),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 236, 236, 236),
              blurRadius: 10.0,
              spreadRadius: 0.5,
              offset: Offset(0, 2))
        ],
      ),
    );
  }
}

class sousCompteLine extends StatelessWidget {
  const sousCompteLine({
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
        InkWell(
            onTap: onPressed,
            radius: 100,
            child: Icon(
              icon,
              size: 30,
              color: couleur,
            )),
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

class transactionInfo extends StatelessWidget {
  const transactionInfo({
    Key? key, required this.date, required this.headLine, required this.message, required this.icon,
  }) : super(key: key);

  final String date;
  final String headLine;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedIcon(
            icon: icon,
            couleur: AppColor.gray,
          ),
          // Container(
          //   height: 44,
          //   width: 44,
          //   decoration: simpleDecoration(colors: AppColor.gray , radius: 90),
          //   child:null ,
          // ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headLine,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColor.textColor1,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  message,
                  maxLines: 3,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromARGB(255, 228, 228, 228)))),
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
