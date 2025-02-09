import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange[900],
      foregroundColor: Colors.white,
    ),
  colorScheme: ColorScheme.dark(
    primary: Colors.orange[800]!,
    secondary: Colors.orange[600]!,
    background: Colors.black,
    surface: Colors.grey[900]!,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.orange[700],
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange[700],
      foregroundColor: Colors.white,
    ),
  ),
  useMaterial3: true,
);
  
}