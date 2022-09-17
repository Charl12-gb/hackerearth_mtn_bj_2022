import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';
import 'package:hackerearth_mtn_bj_2022/Views/optScreen.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uiblock/uiblock.dart';

import '../controllers/utils/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String name = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneNumberFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(
                flex: 10,
              ),
              Text(
                AppLocalizations.of(context)!.welcomeTo,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(AppLocalizations.of(context)!.welcomeToAddNumInfo),
              const Spacer(),
              // INPUT Field
              LoginForm(phoneNumberFieldController: _phoneNumberFieldController),
              const Spacer(),
              // BTN
              appButton(
                  onPressed: () async {
                    await login();
                  },
                text: AppLocalizations.of(context)!.confirm,
                backgroundColor: AppColor.primaryColor
              ),
              const Spacer(
                flex: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    UIBlock.block(context);
    String number = "+229${_phoneNumberFieldController.text}";

    bool isValidPhoneNumber = await validatePhoneNumber(number);

    if(!isValidPhoneNumber){
      await Future(() => UIBlock.unblock(context));
      Future(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidPhoneNumber),behavior: SnackBarBehavior.floating,)));
      return;
    }

    bool hasUser = await FirebaseCore.instance.hasUserWithPhoneNumber(number);

    await FirebaseCore.instance.verifyPhoneNumber(phoneNumber: number, codeAutoRetrievalTimeout: (String verificationId){}, codeSent: (String id, int? resendToken) {
      UIBlock.unblock(context);
      Future(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OPTScreen(verificationId: id, onVerified: () async {
        if(!hasUser){
          await FirebaseCore.instance.createUserInFirestore(phoneNumber: number);
        }
      },
        phoneNumber: number,
      ))));
    }, verificationFailed: (e){
      UIBlock.unblock(context);
      Future(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.verificationFailed),behavior: SnackBarBehavior.floating)));
    }).onError((error, stackTrace) {
      UIBlock.unblock(context);
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorOccur),behavior: SnackBarBehavior.floating));
    });
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.phoneNumberFieldController}) : super(key: key);
  final TextEditingController phoneNumberFieldController;

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
            controller: widget.phoneNumberFieldController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixText: "+229 ",
              hintText: AppLocalizations.of(context)!.phoneNumber,
            ),
          )
        ],
      ),
    );
  }
}
