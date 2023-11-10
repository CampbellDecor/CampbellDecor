import 'package:flutter/material.dart';

// Color lightPrimaryColor = Color(0xFFDF0054);
// Color darkPrimaryColor = Color(0xFF480032);

// Color secondaryColor = Color(0xFFFF8B6A);
// Color accentColor = Color(0xFFFFD2BB);
class ThemeClass {
/*----------------Light Theme Colors------------------*/
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white70.withOpacity(0.5));

  // ThemeData.dark().copyWith(
  // primaryColor: Colors.white, // Accent color
  // backgroundColor: Colors.white, // Background color
  // scaffoldBackgroundColor: Colors.grey[400], // Scaffold background color
  // textTheme: TextTheme(
  // bodyLarge: TextStyle(color: Colors.white), // Text color
  // bodyMedium: TextStyle(color: Colors.white), // Text color
  // ),
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
  // );

/*----------------Dark Theme Colors------------------*/
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    // primaryColor: Colors.blue, // Accent color
    // backgroundColor: Colors.black26, // Background color
    scaffoldBackgroundColor: Colors.grey[900], // Scaffold background color
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Text color
      bodyMedium: TextStyle(color: Colors.white), // Text color
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
  );
  // ThemeData(
  //   brightness: Brightness.dark,
  // );
}
