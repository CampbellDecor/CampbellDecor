import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = Color(0xFFDF0054);
  Color darkPrimaryColor = Color(0xFF480032);
  Color secondaryColor = Color(0xFFFF8B6A);
  Color accentColor = Color(0xFFFFD2BB);

  /*----------------Light Theme Colors------------------*/
  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: ThemeClass().lightPrimaryColor,
      secondary: ThemeClass().secondaryColor,
    ),
  );
  /*----------------Dark Theme Colors------------------*/
  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.red),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: ThemeClass().darkPrimaryColor,
      secondary: ThemeClass().secondaryColor,
    ),
  );
}
