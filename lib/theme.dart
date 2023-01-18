import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2E4057);
const Color secondaryColor = Color(0xFF66A182);

final ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 20,
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 18,
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: primaryColor,
      fontWeight: FontWeight.w400,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    subtitle2: TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.w300,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  ),
);
