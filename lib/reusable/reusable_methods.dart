import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:campbelldecor/imageSample/ImageDemo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../screens/notifications/notification_services.dart';

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

/*-------------------------- Function to update booking statuses ----------------------------*/
void updateBookingStatus() async {
  final CollectionReference bookingsRef =
      FirebaseFirestore.instance.collection('bookings');
  final DateTime currentDate = DateTime.now();

  QuerySnapshot querySnapshot = await bookingsRef.get();
  querySnapshot.docs.forEach((bookingDoc) {
    Map<String, dynamic> bookingData =
        bookingDoc.data() as Map<String, dynamic>;

    String bookingDateString = bookingData['eventDate'];
    DateTime bookingDate = DateTime.parse(bookingDateString);
    if (currentDate.isAfter(bookingDate)) {
      // Update the booking status to "expired"
      bookingDoc.reference.update({'status': 'expired'});
    }
  });
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

Future<void> showInformation(BuildContext context, String inform) async {
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
            child: const Text('OK', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> cancelInformationAlert(BuildContext context, String inform,
    dynamic navigate, String bookingId) async {
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
            child: const Text('Confirm', style: TextStyle(fontSize: 16)),
            onPressed: () async {
              await confirmCancellation(bookingId);
              Navigator.of(context).pop();
              Navigation(context, navigate);
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

Future<String?> getUserNameByEmail(String email) async {
  String? userName;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userName = querySnapshot.docs.first['name'];
    }
  } catch (e) {
    print('Error getting user data: $e');
  }
  return userName;
}

Future<void> insertData(
    String collection,
    String name,
    String status,
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
      'status': status
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

void sendNotification(String id) {
  final NotificationServices notificationServices = NotificationServices();
  notificationServices.getDeviceToken().then((value) async {
    var data = {
      'to':
          'ecpxq0aGR8q8wtnuwJwek1:APA91bGhsQT9PzhXipWTeM5NiwRu_exYgRssB-bdIVX08bOpMRoEO0D8s2404yUBRwqTfPsvnhndeBBHx739bChA-9rAouj2Cpkkau6TiAGsm5hVkWvAGk0EsKUEaKIO575mGZXT5QyR',
      'priority': 'high',
      'notification': {
        'title': 'Booking Confirmation',
        'body': 'Update My Booking',
      },
      'data': {'id': id}
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAliCh-R8:APA91bGSDvwcL3obmsYq7k3A3ueBbHm-SNDdKt8Y9RMqA7Ywi2U4o72j6WRZMiEQF4GPhuYsNlqwH6-RMgvigiQbuXTq42sjuG4zySquDBk0gN-zyHbCeIwHMHNXhHxrfLDKG02tgrKt'
        });
  });
}

Future<void> clearAllSharedPreferenceData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

/*---------------------- Send Notifications Devic to Another Device ---------------------------*/
// ElevatedButton(
//                       onPressed: () {
//                         notificationServices
//                             .getDeviceToken()
//                             .then((value) async {
//                           var data = {
//                             'to':
//                                 'emHO-ms5RxqdWIxch_QGsJ:APA91bFVXTHvikBswj9E8Ug2HyLN8kbcStQ5bmCrER1DTxrBN87kbezlAi2vtDbxwR4iXx5lhd7Ni3c1AOW8tsnGZFwHyXha3LKsmCAGqMBA3byzsyV7aX63Vy-ECyMbpm6pjfkiomtJ',
//                             'priority': 'high',
//                             'notification': {
//                               'title': 'Pinthushan',
//                               'body': 'Subscripe to my Channel',
//                             },
//                             'data': {'type': 'msj', 'id': 'pinthu07'}
//                           };
//                           await http.post(
//                               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                               body: jsonEncode(data),
//                               headers: {
//                                 'Content-Type':
//                                     'application/json; charset=UTF-8',
//                                 'Authorization':
//                                     'key=AAAAliCh-R8:APA91bGSDvwcL3obmsYq7k3A3ueBbHm-SNDdKt8Y9RMqA7Ywi2U4o72j6WRZMiEQF4GPhuYsNlqwH6-RMgvigiQbuXTq42sjuG4zySquDBk0gN-zyHbCeIwHMHNXhHxrfLDKG02tgrKt'
//                               });
//                         });
//                       },
//                       child: Text('SendNotification')),

/****************************/
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

var verificationId;
Future<void> phoneAuthentication(String phoneNo) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNo,
    verificationCompleted: (credential) async {
      await _auth.signInWithCredential(credential);
    },
    codeSent: (verificationId, resendToken) {
      verificationId = verificationId;
    },
    codeAutoRetrievalTimeout: (verificationId) {
      verificationId = verificationId;
    },
    verificationFailed: (e) {
      if (e.code == 'invalid-phone-number') {
        print('Invalid Number');
      } else {
        print('Something Wrong please try again');
      }
    },
  );
}

Future<bool> verifyOTP(String otp) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp));

  return credentials.user != null ? true : false;
}

Future<void> userImagePicker(BuildContext context) async {
  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) {
      return;
    }

    final user = FirebaseFirestore.instance.collection('users');
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child('Users/');
    final uniqueFileName = uid;
    final fileName = imagesRef.child(uniqueFileName);

    final uploadTask = fileName.putFile(File(file.path));

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          print("Upload error: ");
          break;
        case TaskState.success:
          print("Upload successful.");
          break;
      }
    });

    final imageUrl = await fileName.getDownloadURL();
    await user.doc(uid).update({'imgURL': imageUrl});
  } catch (error) {
    print("Error: $error");
  }
}
