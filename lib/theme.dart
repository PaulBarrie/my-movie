import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2E4057);
const Color secondaryColor = Color(0xFF66A182);

final ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontSize: 20,
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: primaryColor,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
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
