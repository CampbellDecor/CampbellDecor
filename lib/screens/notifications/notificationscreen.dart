import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const route = '/notificationscreen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${message.notification?.title}'),
            Text('${message.notification?.body}'),
            Text('${message.data}'),
            ElevatedButton(onPressed: () {}, child: Text('OKAY'))
          ],
        ),
      ),
    );
  }
}

/**********************************/
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/notificationModel.dart';
// import 'firestoreProvider.dart';

// class NotificationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: Consumer<FirestoreProvider>(
//         builder: (context, firestoreProvider, child) {
//           final notifications = firestoreProvider.getNotifications();
//           return FutureBuilder<List<FirestoreNotification>>(
//             future: notifications,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Text('No notifications available.');
//               } else {
//                 final notificationList = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: notificationList.length,
//                   itemBuilder: (context, index) {
//                     final notification = notificationList[index];
//                     return ListTile(
//                       title: Text(notification.title),
//                       subtitle: Text(notification.message),
//                       trailing: Text(notification.timestamp.toString()),
//                     );
//                   },
//                 );
//               }
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           final newNotification = FirestoreNotification(
//             title: 'New Notification',
//             message: 'This is a new notification.',
//             timestamp: DateTime.now(),
//           );
//           Provider.of<FirestoreProvider>(context, listen: false)
//               .addNotification(newNotification);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
