import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.green,
    background: Colors.grey.shade200,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline3: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
    bodyText2: TextStyle(fontSize: 14.0, color: Colors.black),
    button: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.teal,
    background: Colors.grey.shade900,
    surface: Colors.grey.shade800,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline3: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
    bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
    button: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueGrey,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade700,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
);
