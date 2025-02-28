import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,// Color específico para encabezados
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
          ),
        ),
    colorScheme: ColorScheme.dark(
      primary: Colors.orange[800]!,
      secondary: Colors.orange[600]!,
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