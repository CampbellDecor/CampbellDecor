import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<int> getCollectionCount(String collectionName) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await collectionRef.get();
    return querySnapshot.size;
  } catch (e) {
    print('Error getting collection count: $e');
    return 0;
  }
}

Future<void> Navigation(BuildContext context, dynamic function) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => function));
}

/**********************************************************************************/
Future<void> requestCancellation(String bookingId) async {
  try {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'pending_cancellation'});
    print('Cancellation requested');
  } catch (e) {
    print('Error requesting cancellation: $e');
  }
}

Future<void> confirmCancellation(String bookingId) async {
  try {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'cancelled'});
    print('Cancellation confirmed');
  } catch (e) {
    print('Error confirming cancellation: $e');
  }
}

// Future<void> sendPushNotification(String requestId) async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   String adminFCMToken =
//       'elSu8tgKT4ukN2q6UFrecA:APA91bHVoX9x2OixUCP7ua5S33xLDL_TMhTaK8FLFRc3Ydc2GJPdmK9AwBPM4DZ-dIdj3xuVlF-vrx0xzuakGGRUUYk9dT41NKbc0apHPxrHYLw4WWnKpASs3Vat1J5adjAERjcd3c4a';
//   Map<String, String> notificationData = {
//     'requestId': requestId,
//     'title': 'New Cancellation Request',
//     'body': 'A new cancellation request has been made.',
//   };
//
//   if (messaging == null) {
//     print('FirebaseMessaging instance is null.');
//     return;
//   } else {
//     try {
//       await messaging.sendMessage(
//         to: 'elSu8tgKT4ukN2q6UFrecA:APA91bHVoX9x2OixUCP7ua5S33xLDL_TMhTaK8FLFRc3Ydc2GJPdmK9AwBPM4DZ-dIdj3xuVlF-vrx0xzuakGGRUUYk9dT41NKbc0apHPxrHYLw4WWnKpASs3Vat1J5adjAERjcd3c4a',
//         data: notificationData,
//       );
//       print('Push notification sent successfully');
//     } catch (e) {
//       print('Error sending push notification: ${e.toString()}');
//     }
//   }
// }
Future<void> sendPushNotification(String requestId) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String adminFCMToken =
      'elSu8tgKT4ukN2q6UFrecA:APA91bHVoX9x2OixUCP7ua5S33xLDL_TMhTaK8FLFRc3Ydc2GJPdmK9AwBPM4DZ-dIdj3xuVlF-vrx0xzuakGGRUUYk9dT41NKbc0apHPxrHYLw4WWnKpASs3Vat1J5adjAERjcd3c4a'; // Replace with your FCM token
  Map<String, String> notificationData = {
    'requestId': requestId,
    'title': 'New Cancellation Request',
    'body': 'A new cancellation request has been made.',
  };

  if (messaging == null) {
    print('FirebaseMessaging instance is null.');
    return;
  } else {
    try {
      await messaging.sendMessage(
        to: adminFCMToken,
        data: notificationData,
      );
      print('Push notification sent successfully');
    } catch (e) {
      print('Error sending push notification: ${e.toString()}');
    }
  }
}

/*********************************************************************************/
Future<void> showInformationAlert(
    BuildContext context, String inform, dynamic function) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.blue,
        ),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Information'),
          ),
        ),
        content: Text(
          inform,
          style: const TextStyle(color: Colors.blue, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigation(context, function);
            },
          ),
        ],
      );
    },
  );
}

Future<void> showErrorAlert(BuildContext context, String errorMessage) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.error_rounded,
          color: Colors.red,
        ),
        title: const Text('Error'),
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String?> getData(dynamic name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(name);
}

Future<double?> getDoubleData(dynamic name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(name);
}

Future<List<String?>> getListData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? list = prefs.getStringList(key);
  return list ?? [];
}

Future<Map<String, dynamic>> getMapData(String service) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonData = prefs.getString(service) ?? '{}'; // Default to empty map
  Map<String, dynamic> mapData = json.decode(jsonData);
  return mapData;
}

Future<void> insertData(
    String collection,
    String name,
    String UserID,
    DateTime date,
    DateTime eventDate,
    double paymentAmount,
    Map<String, dynamic> myMap) async {
  try {
    CollectionReference parentCollection =
        FirebaseFirestore.instance.collection(collection);
    DocumentReference parentDocument = await parentCollection.add({
      'name': name,
      'userID': UserID,
      'date': date,
      'eventDate': eventDate,
      'paymentAmount': paymentAmount,
    });
    CollectionReference subCollection =
        await parentDocument.collection('service');
    await subCollection.add(myMap);
  } catch (e) {
    print('Error inserting data: $e');
  }
  // parentCollection.doc().set({
  //   'name': name,
  //   'userID': UserID,
  //   'date': date,
  //   'amount': amount,
  // }).then((_) async {
  //   print('User Event Added successfully');
  // }).catchError((error) {
  //   print('Failed to Add User Event: $error');
  // });
}

// void insertData() async {
//   try {
//     CollectionReference parentCollection =
//         FirebaseFirestore.instance.collection('parentCollection');
//     DocumentReference parentDocument =
//         await parentCollection.add({'field1': 'value1'});
//
//     CollectionReference subCollection =
//         parentDocument.collection('subCollection');
//     await subCollection
//         .add({'subField1': 'subValue1', 'subField2': 'subValue2'});
//   } catch (e) {
//     print('Error inserting data: $e');
//   }
// }
