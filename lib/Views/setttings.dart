import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/home.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AdaptiveThemeMode savedThemeMode = AdaptiveThemeMode.system;
  Locale get locale => Localizations.localeOf(context);

  @override
  void initState() {
    AdaptiveTheme.getThemeMode().then((value) => setState(() => savedThemeMode=value??savedThemeMode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              AppLocalizations.of(context)!.settings,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  AppLocalizations.of(context)!.account,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, AppLocalizations.of(context)!.language,(stateSet){
              return [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    stateSet.call(() {
                    },);
                  },
                  child: Row(
                    children: [
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith((states) => AppColor.primaryColor),
                        value: 0,
                        onChanged: (int? value) {
                          stateSet.call(() {
                          },);
                        }, groupValue: 1,
                      ),
                      Text(AppLocalizations.of(context)!.english),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    stateSet.call(() {
                    },);
                  },
                  child: Row(
                    children: [
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith((states) => AppColor.primaryColor),
                        value: 1,
                        onChanged: (int? value) {
                          stateSet.call(() {
                          },);
                        }, groupValue: 1,
                      ),
                      Text(AppLocalizations.of(context)!.french),
                    ],
                  ),
                ),
              ];
            }),
            const SizedBox(
              height: 15,
            ),
            buildAccountOptionRow(context, AppLocalizations.of(context)!.darkMode, (stateSet){
              return [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    AdaptiveTheme.of(context).setSystem();
                    stateSet.call(() {
                      savedThemeMode = AdaptiveThemeMode.system;
                    },);
                  },
                  child: Row(
                    children: [
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith((states) => AppColor.primaryColor),
                        value: savedThemeMode==AdaptiveThemeMode.system?1:0,
                        onChanged: (int? value) {
                          AdaptiveTheme.of(context).setSystem();
                          stateSet.call(() {
                            savedThemeMode = AdaptiveThemeMode.system;
                          },);
                        }, groupValue: 1,
                      ),
                      Text(AppLocalizations.of(context)!.system),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    AdaptiveTheme.of(context).setLight();
                    stateSet.call(() {
                      savedThemeMode = AdaptiveThemeMode.light;
                    },);
                  },
                  child: Row(
                    children: [
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith((states) => AppColor.primaryColor),
                        value: savedThemeMode==AdaptiveThemeMode.light?1:0,
                        onChanged: (int? value) {
                          AdaptiveTheme.of(context).setLight();
                          stateSet.call(() {
                            savedThemeMode = AdaptiveThemeMode.light;
                          },);
                        }, groupValue: 1,
                      ),
                      Text(AppLocalizations.of(context)!.lightMode),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    AdaptiveTheme.of(context).setDark();
                    stateSet.call(() {
                      savedThemeMode = AdaptiveThemeMode.dark;
                    },);
                  },
                  child: Row(
                    children: [
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith((states) => AppColor.primaryColor),
                        value:savedThemeMode==AdaptiveThemeMode.dark?1:0,
                        onChanged: (int? value) {
                          AdaptiveTheme.of(context).setDark();
                          stateSet.call(() {
                            savedThemeMode = AdaptiveThemeMode.dark;
                          },);
                        }, groupValue: 1,
                      ),
                      Text(AppLocalizations.of(context)!.darkMode),
                    ],
                  ),
                ),
              ];
            }),
            const SizedBox(
              height: 15,
            ),
            buildAccountOptionRow(context, AppLocalizations.of(context)!.about, (stateSet){
              return [
                const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis id consequat orci. Cras venenatis id urna at mollis. Suspendisse eu quam quam. Morbi nec ornare quam. Phasellus aliquam scelerisque gravida. Praesent sed ultricies felis. Sed a eros in ligula congue venenatis et non eros. Morbi magna tellus, sagittis quis ex scelerisque, facilisis sollicitudin urna.In blandit lorem eros, id interdum erat mattis eget. Vestibulum pretium elementum ante. In lectus felis, sagittis sed est ac, mollis laoreet lectus. Donec auctor odio sit amet justo tincidunt, quis interdum felis rutrum. Praesent finibus id est a blandit. Nam ut dolor finibus, tristique nibh ut, blandit elit. Maecenas fermentum semper urna sodales fringilla. Nulla gravida, massa eu finibus rutrum, metus nulla aliquet eros, sed facilisis sapien orci eget tortor. Ut vel nibh et enim lobortis accumsan. Pellentesque laoreet diam id nibh interdum, in rutrum elit facilisis. Sed in porttitor lectus, non commodo magna. Maecenas condimentum urna nec nunc pretium, et rhoncus ligula fermentum. Curabitur consequat pellentesque dolor, vel vehicula ligula aliquet id. Etiam egestas feugiat ante sed fermentum.")
              ];
            }),
            const SizedBox(
              height: 15,
            ),
            Center(child: TextButton(onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (route) => false,);
              });
            }, child: Text(AppLocalizations.of(context)!.signOut),)),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: AppColor.primaryColor,
              value: isActive,
              onChanged: (bool val) => onChanged.call(val),
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title, List<Widget> Function(Function(VoidCallback fn) setState) content) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  title: Text(title),
                  content: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content.call(setState),
                    ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}