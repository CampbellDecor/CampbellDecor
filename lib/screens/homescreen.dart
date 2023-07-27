import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:flutter/material.dart';

ThemeManager _themeMode = ThemeManager();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('home page'),
          actions: [
            Switch(
              value: false,
              onChanged: (newValue) {
                _themeMode.toggleTheme(newValue);
              },
            )
          ],
        ),
        body: const Center(
          child: Text('Home Page'),
        ));
  }
}
