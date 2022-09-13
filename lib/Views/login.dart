import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/components/components.dart';
import 'package:hackerearth_mtn_bj_2022/Views/optScreen.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  static String name = "/login";

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
                "Bienvenu sur MTN",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor1
                    ),
              ),
              Spacer(),
              Text(
                  "Entrez votre numero de téléphone pour vous authentifier \nà notre application MTN Challenge"),
              Spacer(),
              // INPUT Field
              LoginForm(),
              Spacer(),
              // BTN
              appButton(
                onPressed: () {
                  Navigator.pushNamed(context, OPTScreen.name);
                }, 
                text: "confirmer",
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
