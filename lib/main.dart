import 'package:campbelldecor/screens/bookingscreen.dart';
import 'package:campbelldecor/screens/cartscreen.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/events_screen/serviceselectscreen.dart';
import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:campbelldecor/screens/events_screen/usereventscreation.dart';
import 'package:campbelldecor/screens/ltest1.dart';
import 'package:campbelldecor/screens/notifications/notification_setup.dart';
import 'package:campbelldecor/screens/notifications/notificationscreen.dart';
import 'package:campbelldecor/screens/test03.dart';
import 'package:campbelldecor/screens/theme/theme_colors.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            final themeManager = Provider.of<ThemeManager>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeClass.lightTheme,
              darkTheme: ThemeClass.darkTheme,
              themeMode: themeManager.themeMode,
              home: EventsScreen(),
              navigatorKey: navigatorKey,
              routes: {
                NotificationScreen.route: (context) =>
                    const NotificationScreen(),
              },
            );
          },
        ));
  }
}
