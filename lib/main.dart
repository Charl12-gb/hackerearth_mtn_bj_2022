import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/Views/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hackerearth_mtn_bj_2022/routes.dart';

import 'Views/theme_provider.dart';
import 'controllers/navigation_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // initializeDateFormatting("fr_FR", null).then((value) => Intl.defaultLocale = 'fr');
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: _themeProvider.lightThemeData(),
      dark: _themeProvider.darkThemeData(),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: AppLocalizations.of(context)?.appName??"Momo Epargne",
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('fr', ''), // Spanish, no country code
        ],
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        // themeMode: ThemeMode.system,
        initialRoute: Login.name,  //OPTScreen.name,
        routes: Routes,
      ),
    );
  }
}