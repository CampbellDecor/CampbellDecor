import 'package:campbelldecor/utils/color_util.dart';
import 'package:flutter/material.dart';

class ThemeClass {
/*----------------Light Theme Colors------------------*/
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

/*----------------Dark Theme Colors------------------*/
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: hexStringtoColor('050118'),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
  );
}
