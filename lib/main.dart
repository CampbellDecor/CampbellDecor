import 'package:campbelldecor/screens/bookings_screens/booking_details_screen.dart';
import 'package:campbelldecor/screens/bookings_screens/custom_rating.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:campbelldecor/screens/theme/theme_colors.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
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
  // await FirebaseApi().initNotification();
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
              home: BookingDetailsScreen(),
              // CustomRatingBar(
              //   maxRating: 5,
              //   initialRating: 60,
              //   onRatingChanged: (rating) {
              //     print('New rating: $rating');
              //   },
              // ),
              navigatorKey: navigatorKey,
              // routes: {
              //   NotificationScreen.route: (context) =>
              //       const NotificationScreen(),
              // },
            );
          },
        ));
  }
}
