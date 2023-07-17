import 'package:campbelldecor/resources/loader.dart';
import 'package:campbelldecor/screens/bookingscreen.dart';
import 'package:campbelldecor/screens/cartscreen.dart';
import 'package:campbelldecor/screens/eventScreen/religion.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ReligionSelectScreen(),
    );
  }
}
