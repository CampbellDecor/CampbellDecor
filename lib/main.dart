import 'package:campbelldecor/screens/homescreen.dart';
import 'package:campbelldecor/screens/ltest1.dart';
import 'package:campbelldecor/screens/notifications/notification_setup.dart';
import 'package:campbelldecor/screens/notifications/notificationscreen.dart';
import 'package:campbelldecor/screens/test.dart';
import 'package:campbelldecor/screens/theme/theme_colors.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

ThemeManager _themeMode = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: _themeMode.themeMode,
      home: const HomeScreen(),
      navigatorKey: navigatorKey,
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen(),
      },
    );
  }
}
