import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

class appButton extends StatelessWidget {
  const appButton({
    Key? key,
    required this.onPressed, this.text, required this.backgroundColor,
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
            backgroundColor: backgroundColor ),//AppColor.primaryColor
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: AppColor.textColor2),
        ),
      ),
    );
  }
}
