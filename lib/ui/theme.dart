// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFFF37257);
const Color secondaryClr = Color(0xFFF68D5C);
const Color thirdClr = Color(0xFFF4D27A);
const Color yellowClr = Color(0xFF517281);
const Color pinkClr = Color(0xFF7895A2);
const Color white = Color(0xAFC1CC);
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
    primaryColorLight: secondaryClr,
    primaryColorDark: thirdClr,
    colorScheme: ColorScheme(
      primary: primaryClr,
      primaryVariant: secondaryClr,
      secondary: thirdClr,
      secondaryVariant: Color(0xffEC6C3F),
      surface: Color(0xffF2D479),
      background: pinkClr,
      error: Color(0xffDE9D7F),
      onPrimary: Color(0xff2C5700),
      onSecondary: Color(0xffAFD775),
      onSurface: Color(0xff95CBE9),
      onBackground: Color(0xff024769),
      onError: Colors.red,
      brightness: Brightness.light,
    ),

    // scaffoldBackgroundColor: Colors.amberAccent
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]));
}
