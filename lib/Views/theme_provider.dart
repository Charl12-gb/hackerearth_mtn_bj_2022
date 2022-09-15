import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackerearth_mtn_bj_2022/colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider();

  ThemeData lightThemeData() {
    return ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: AppColor.contentColorLightTheme),
          centerTitle: false,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColor.contentColorDarkTheme,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white),
      iconTheme: const IconThemeData(color: AppColor.contentColorLightTheme),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          headline1: GoogleFonts.poppins(
              fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: GoogleFonts.poppins(
              fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3:
              GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w400),
          headline4: GoogleFonts.poppins(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headline5:
              GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          headline6: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          caption: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: GoogleFonts.poppins(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      ).apply(bodyColor: AppColor.contentColorLightTheme),
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        error: AppColor.errorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColor.contentColorLightTheme.withOpacity(0.7),
        unselectedItemColor: AppColor.contentColorLightTheme.withOpacity(0.32),
        selectedIconTheme: const IconThemeData(color: AppColor.primaryColor),
        showUnselectedLabels: true,
      ),
    );
  }

  ThemeData darkThemeData() {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: AppColor.contentColorLightTheme,
      backgroundColor: AppColor.contentColorLightTheme,
      appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColor.contentColorDarkTheme),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColor.contentColorLightTheme,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          backgroundColor: AppColor.contentColorLightTheme),
      iconTheme: const IconThemeData(color: AppColor.contentColorDarkTheme),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          headline1: GoogleFonts.poppins(
              fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: GoogleFonts.poppins(
              fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3:
          GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w400),
          headline4: GoogleFonts.poppins(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headline5:
          GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          headline6: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          caption: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: GoogleFonts.poppins(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      ).apply(bodyColor: AppColor.contentColorDarkTheme),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        error: AppColor.errorColor,
      ),
      canvasColor: AppColor.contentColorLightTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColor.contentColorLightTheme,
        selectedItemColor: Colors.white70,
        unselectedItemColor: AppColor.contentColorDarkTheme.withOpacity(0.32),
        selectedIconTheme: const IconThemeData(color: AppColor.primaryColor),
        showUnselectedLabels: true,
      ),
    );
  }
}
