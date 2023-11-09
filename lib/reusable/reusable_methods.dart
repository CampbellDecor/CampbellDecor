import 'dart:convert';
import 'dart:io';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // Navigator.push(context, MaterialPageRoute(builder: (context) => function));
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.rightToLeft,
      child: function,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 500),
    ),
    // PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) {
    //     return function;
    //   },
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     const begin = Offset(0.0, 1.0);
    //     const end = Offset.zero;
    //     const curve = Curves.easeInOut;
    //     const duration = Duration(milliseconds: 500);
    //
    //     var offsetAnimation = animation.drive(
    //       Tween(begin: begin, end: end).chain(
    //         CurveTween(curve: curve),
    //       ),
    //     );
    //
    //     return SlideTransition(
    //       position: offsetAnimation,
    //       child: child,
    //     );
    //   },
    // ),
  );

  // Get.to(() => function(), transition: Transition.zoom);
}

Future<void> NavigationWithoutAnimation(
    BuildContext context, dynamic function) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => function));
  // Navigator.push(
  //   context,
  //   PageTransition(
  //     type: PageTransitionType.rightToLeft,
  //     child: function,
  //     duration: Duration(milliseconds: 600),
  //     reverseDuration: Duration(milliseconds: 500),
  //   ),
  //   // PageRouteBuilder(
  //   //   pageBuilder: (context, animation, secondaryAnimation) {
  //   //     return function;
  //   //   },
  //   //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //   //     const begin = Offset(0.0, 1.0);
  //   //     const end = Offset.zero;
  //   //     const curve = Curves.easeInOut;
  //   //     const duration = Duration(milliseconds: 500);
  //   //
  //   //     var offsetAnimation = animation.drive(
  //   //       Tween(begin: begin, end: end).chain(
  //   //         CurveTween(curve: curve),
  //   //       ),
  //   //     );
  //   //
  //   //     return SlideTransition(
  //   //       position: offsetAnimation,
  //   //       child: child,
  //   //     );
  //   //   },
  //   // ),
  // );

  // Get.to(() => function(), transition: Transition.zoom);
}

Future<void> BottomNavigation(BuildContext context, dynamic function) async {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.bottomToTop,
      child: function,
      duration: Duration(milliseconds: 100),
      reverseDuration: Duration(milliseconds: 100),
    ),

    // PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) {
    //     return function;
    //   },
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     const begin = Offset(0.0, 1.0);
    //     const end = Offset.zero;
    //     const curve = Curves.easeInOut;
    //     const duration = Duration(milliseconds: 500);
    //
    //     var offsetAnimation = animation.drive(
    //       Tween(begin: begin, end: end).chain(
    //         CurveTween(curve: curve),
    //       ),
    //     );
    //
    //     return SlideTransition(
    //       position: offsetAnimation,
    //       child: child,
    //     );
    //   },
    // ),
  );

  // Get.to(() => function(), transition: Transition.zoom);
}

Future<void> BottomNavigationForHome(
    BuildContext context, dynamic function) async {
  NavigationWithoutAnimation(context, function);

  // PageRouteBuilder(
  //   pageBuilder: (context, animation, secondaryAnimation) {
  //     return function;
  //   },
  //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //     const begin = Offset(0.0, 1.0);
  //     const end = Offset.zero;
  //     const curve = Curves.easeInOut;
  //     const duration = Duration(milliseconds: 500);
  //
  //     var offsetAnimation = animation.drive(
  //       Tween(begin: begin, end: end).chain(
  //         CurveTween(curve: curve),
  //       ),
  //     );
  //
  //     return SlideTransition(
  //       position: offsetAnimation,
  //       child: child,
  //     );
  //   },
  // ),

  // Get.to(() => function(), transition: Transition.zoom);
}

// void navigateToDestinationPage(BuildContext context) {
//   Navigator.push(
//     context,
//     PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return YourDestinationPage();
//       },
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.easeInOut;
//
//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//         var offsetAnimation = animation.drive(tween);
//
//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//     ),
//   );
// }

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
// void updateBookingStatus() async {
//   final CollectionReference bookingsRef =
//       FirebaseFirestore.instance.collection('bookings');
//   final DateTime currentDate = DateTime.now();
//
//   QuerySnapshot querySnapshot = await bookingsRef.get();
//   querySnapshot.docs.forEach((bookingDoc) {
//     Map<String, dynamic> bookingData =
//         bookingDoc.data() as Map<String, dynamic>;
//
//     String bookingDateString = bookingData['eventDate'];
//     DateTime bookingDate = DateTime.parse(bookingDateString);
//     if (currentDate.isAfter(bookingDate)) {
//       // Update the booking status to "expired"
//       bookingDoc.reference.update({'status': 'expired'});
//     }
//   });
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

Future<void> cancelInformationAlert(
    BuildContext context, String inform, String bookingId) async {
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
        backgroundColor: Colors.white.withOpacity(0.7),
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.error_rounded,
          size: 40,
          color: Colors.red,
        ),
        title: const Text('Error'),
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
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
}

Future<void> updateDeviceTokenForNotification(String userId) async {
  NotificationServices notificationServices = NotificationServices();
  notificationServices.getDeviceToken().then((value) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userReference = firestore.collection('users').doc(userId);

      await userReference.update({
        'deviceTokenForNotification': value,
      });

      print('User age updated successfully');
    } catch (e) {
      print('Error updating user age: $e');
    }
  });
}

Future<void> sendNotificationForAdmin(String id) async {
  var data = {
    'to':
        'c89jyGQ8SaSiy3H05Lmp3N:APA91bFKipKaz3IzkUFP7KjlYu90NJPBS87wyWkX6e5mMf6EtNnqldXjJJp-Db32vaJutwqofS'
            '-DdrnNb7Oxvd6yeoelRHwaU71VwryUQoEi6jr5XuhUM4TL8xlw6DH0lsFgNbBVFbS9',
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
}

Future<void> clearAllSharedPreferenceData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

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

Future<void> setOutDatedBooking() async {
  await FirebaseFirestore.instance
      .collection('bookings')
      .where('eventDate', isLessThan: DateTime.now())
      .get()
      .then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      if (doc.get('status') != 'cancelled') {
        outDatedBookings(doc.id);
      }
      print(doc.get('status'));
    });
  });
}

Future<void> outDatedBookings(String id) async {
  await FirebaseFirestore.instance
      .collection('bookings')
      .doc(id)
      .update({'status': 'expired'});
}
