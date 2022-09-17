import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uiblock/uiblock.dart';

import '../controllers/firebase_core.dart';
import 'home.dart';

class OPTScreen extends StatefulWidget {
  const OPTScreen({Key? key, this.phoneNumber = "", this.verificationId = "", this.onVerified}) : super(key: key);
  static String name = "/opt";
  final String phoneNumber;
  final String verificationId;
  final Function()? onVerified;

  @override
  State<OPTScreen> createState() => _OPTScreenState();
}

class _OPTScreenState extends State<OPTScreen> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String _code = '';
  final int _start = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(flex: 4,),
              Text(
                AppLocalizations.of(context)!.codeInputMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textColor1,
                    fontSize: 22),
              ),
              Text(
                AppLocalizations.of(context)!.codeConfiMsg,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor2),
              ),
              Text(widget.phoneNumber.replaceRange(6, widget.phoneNumber.length, "********"),
                textAlign: TextAlign.center,
              ),
              VerificationCode(
                length: 6,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                onCompleted: (value) {
                  setState(() {
                    _code = value;
                  });
                },
                onEditing: (value) {},
              ),
              TweenAnimationBuilder(
                tween: Tween(begin: 30.0 , end: 0),
                duration: const Duration(seconds: 30),
                builder: (context, sec, child) => Text("Waiting for confirmation 00 : ${ num.parse(sec.toString()).toInt() }") ,
              ),

              const Spacer(flex: 1,),
              appButton(
                onPressed: _code.length < 6 ? () => {} : () { verify(); },
                text: AppLocalizations.of(context)!.btnConfirm , backgroundColor: AppColor.primaryColor,
              ),
              const Spacer(flex: 5,),
            ],
          ),
        ),
      ),
    );
  }

  void verify() async {
    UIBlock.block(context);

    await FirebaseCore.instance.sendCodeToFirebase(code: _code, verificationId: widget.verificationId, updatePhoneNumber:false).then((value) async {
      if(value){
        await widget.onVerified?.call();
        await Future(() => UIBlock.unblock(context));
        Future(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false));
        return;
      }
      await Future(() => UIBlock.unblock(context));
      Future(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.incorrectCodeMsg),behavior: SnackBarBehavior.floating)));
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      UIBlock.unblock(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorProduit),behavior: SnackBarBehavior.floating));
    });
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.phoneNumber,
            ),
          )
        ],
      ),
    );
  }
}
