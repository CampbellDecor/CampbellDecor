// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class NotificationSetup extends StatefulWidget {
//   const NotificationSetup({super.key});
//
//   @override
//   State<NotificationSetup> createState() => _NotificationSetupState();
// }
//
// class _NotificationSetupState extends State<NotificationSetup> {
//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//
//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }
//
//   void _handleMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       Navigator.pushNamed(
//         context,
//         '/chat',
//         arguments: message,
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Run code required to handle interacted messages in an async function
//     // as initState() must not be async
//     setupInteractedMessage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text("...");
//   }
//
//
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   NotificationSettings settings = await messaging.requestPermission(
//   alert: true,
//   announcement: false,
//   badge: true,
//   carPlay: false,
//   criticalAlert: false,
//   provisional: false,
//   sound: true,
//   );
//
//   print('User granted permission: ${settings.authorizationStatus}');
// }
