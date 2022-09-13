import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';
import 'package:hackerearth_mtn_bj_2022/Views/home.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

class OPTScreen extends StatelessWidget {
  const OPTScreen({Key? key}) : super(key: key);
  static String name = "/opt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Spacer(flex: 4,),
              Text(
                "Saisissez le code de \n confirmation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textColor1,
                    fontSize: 22),
              ),
              Text(
                "Entrez le code à 5 chiffre que nous avons envoyé à",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor2),
              ),
              Text(
                "+229 ** ** 55 64",
                textAlign: TextAlign.center,
              ),
              pinForm(),
              Spacer(flex: 1,),

              TweenAnimationBuilder(
                tween: Tween(begin: 30.0 , end: 0), 
                duration: const Duration(seconds: 30), 
                builder: (context, sec, child) => Text("En attente de confirmation 00 : ${ num.parse(sec.toString()).toInt() }") ,
              ),
              
              Spacer(flex: 1,),
              appButton(onPressed: () {
                Navigator.pushNamed(context, Home.name);
              } , text: "Confirmer" , backgroundColor: AppColor.primaryColor),
              Spacer(flex: 5,),
            ],
          ),
        ),
      ),
    );
  }
}

class pinForm extends StatefulWidget {
  const pinForm({
    Key? key,
  }) : super(key: key);

  @override
  State<pinForm> createState() => _pinFormState();
}

class _pinFormState extends State<pinForm> {
  FocusNode? focus2;
  FocusNode? focus3;
  FocusNode? focus4;
  FocusNode? focus5;

  @override
  void initState() {
    super.initState();
    focus2 = FocusNode();
    focus3 = FocusNode();
    focus4 = FocusNode();
    focus5 = FocusNode();
  }

  @override
  void dispose() {
    focus2!.dispose();
    focus3!.dispose();
    focus4!.dispose();
    focus5!.dispose();
    super.dispose();
  }

  void _nextField({String? value, FocusNode? focus}) {
    if (value!.length == 1) {
      focus!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Spacer(
            flex: 2,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _nextField(value: value, focus: focus2);
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _nextField(value: value, focus: focus3);
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _nextField(value: value, focus: focus4);
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _nextField(value: value, focus: focus5);
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                focus5!.unfocus();
              },
            ),
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
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
        children: const [
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Numero de Téléphone",
            ),
          )
        ],
      ),
    );
  }
}
