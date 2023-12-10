import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../models/invoice.dart';
import '../models/supplier.dart';
import '../models/user_model.dart';
import 'package:pdf/widgets.dart' as pw;

import '../screens/notifications/notification_setup.dart';

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

// Future<Map<String, dynamic>> fetchDataFromFirebase(
//     String collection, String orderField, String uid) async {
//   Map<String, dynamic> resultMap = {};
//
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection(collection)
//         .where('userID', isEqualTo: uid)
//         .orderBy(orderField, descending: true)
//         .get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       querySnapshot.docs.forEach((doc) {
//         resultMap[doc.get('eventDate').toString()] = doc.data();
//       });
//       print(resultMap);
//       print(resultMap);
//       print(resultMap);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
//
//   return resultMap;
// }

Future<Map<String, dynamic>> fetchDataFromFirebase(
    String collection, String orderField, String uid) async {
  Map<String, dynamic> resultMap = {};

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('userID', isEqualTo: uid)
        .where('status', isEqualTo: 'active')
        .orderBy(orderField, descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      resultMap = querySnapshot.docs.first.data() as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error: $e');
  }

  return resultMap;
}

Future<void> Navigation(BuildContext context, dynamic function) async {
  // Navigator.push(context, MaterialPageRoute(builder: (context) => function));
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.rightToLeft,
      child: function,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 150),
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

/**---------------------Dialog box Start-----------------------**/
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
          size: 40,
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
          size: 40,
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
          size: 40,
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
        backgroundColor: Colors.white.withOpacity(0.9),
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.error_outline,
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

/**---------------------Dialog box end-----------------------**/

/**--------------------- Shared references start-----------------------**/

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

Future<void> clearAllSharedPreferenceData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("pppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "ppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"
      "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
}

/**--------------------- Shared references end-----------------------**/

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
    bool isRated,
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
      'status': status,
      'isRated': isRated,
      'pdf': null
    });
    CollectionReference subCollection =
        await parentDocument.collection('service');
    await subCollection.add(myMap);
  } catch (e) {
    print('Error inserting data: $e');
  }
}

Future<void> updateDeviceTokenForNotification(String userId) async {
  FirebaseApi notificationServices = FirebaseApi();
  notificationServices.getDeviceToken().then((value) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userReference = firestore.collection('users').doc(userId);

      await userReference.update({
        'deviceTokenForNotification': value,
      });

      print('Device token  updated successfully');
    } catch (e) {
      print('Error updating user age: $e');
    }
  });
}

Future<void> sendNotificationForAdmin(String id, String heading, String details,
    String name, double payment, DateTime eventDate) async {
  Map<String, dynamic> user =
      await getUserData(FirebaseAuth.instance.currentUser!.uid);
  var data = {
    'to': user['deviceTokenForNotification'],
    'priority': 'high',
    'notification': {
      'title': 'Booking Confirmation',
      'body': 'Update My Booking',
    },
    'data': {
      'id': id,
      'head': heading,
      'body': details,
      'name': name,
      'payment': payment,
      'eventDate': eventDate.toString(),
      'dateTime': DateTime.now().toString()
    }
  };
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAliCh-R8:APA91bGSDvwcL3obmsYq7k3A3ueBbHm-SNDdKt8Y9RMqA7Ywi2U4o72j6WRZMiEQF4GPhuYsNlqwH6-RMgvigiQbuXTq42sjuG4zySquDBk0gN-zyHbCeIwHMHNXhHxrfLDKG02tgrKt'
      });
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

Future<void> savePdfForFirebase(File file, String id) async {
  Reference storageReference =
      FirebaseStorage.instance.ref().child('pdfs').child('$id.pdf');
  UploadTask uploadTask = storageReference.putFile(file);
  await uploadTask.whenComplete(() async {
    String downloadURL = await storageReference.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(id)
        .update({'pdf': downloadURL});
  });
}

Future<pw.Image> imageGenerate() async {
  final img = await rootBundle.load('assets/images/appLogo1.png');
  final imageBytes = img.buffer.asUint8List();
  pw.Image image = pw.Image(pw.MemoryImage(imageBytes));
  return image;
}

Future<void> GeneratePDFInvoice(
  Map<String, dynamic> user,
  Map<String, dynamic> event,
  String bookingId,
  double total,
) async {
  final date = DateTime.now();

  final invoice = Invoice(
    supplier: const Supplier(
      name: 'Campbell Decor',
      address: 'Campbell Town,\nNSW,\nAustralia,2560.',
      paymentInfo: 'https://paypal.me/campbellDecor',
      phone: '+61 410 734 436.',
      email: 'campbelldecorau@gmail.com.',
      website: 'http://www.campbelldecor.com.au/',
    ),
    customer: Customer(
      name: user['name'],
      address: user['address'],
    ),
    info: InvoiceInfo(
      description: 'Description',
      number:
          '${DateTime.now().year}-${DateTime.now().minute}${DateTime.now().microsecond}',
      date: date,
    ),
    items: [
      InvoiceItem(
        description: event['name'],
        eventDate: date,
        amount: event['price'],
      ),
    ],
    image: await imageGenerate(),
  );
  final pdfFile = await PdfInvoiceApi.generate(invoice, bookingId, total);
}

Future<Map<String, dynamic>> getUserData(String id) async {
  Map<String, dynamic> userData = {};
  DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  if (userSnapshot.exists) {
    userData = userSnapshot.data()!;
  }
  return userData;
}

Future<void> updateData(String collection_name, String document_id,
    String field_name, String value) async {
  try {
    await FirebaseFirestore.instance
        .collection(collection_name)
        .doc(document_id)
        .update({field_name: value});
  } catch (e) {
    print('Error Updating: $e');
  }
}

String shortenString(String input, int maxLength) {
  if (input.length <= maxLength) {
    return input;
  } else {
    return '${input.substring(0, maxLength)}...';
  }
}

Future<void> saveNotification(
  String id,
  String head,
  String body,
  String name,
  double payment,
  DateTime eventDate,
  DateTime dateTime,
) async {
  CollectionReference notification =
      await FirebaseFirestore.instance.collection('notification');
  try {
    await notification.add({
      'bookId': id,
      'head': head,
      'body': body,
      'name': name,
      'eventDateTime': eventDate,
      'payment': payment,
      'dateTime': dateTime,
      'uid': FirebaseAuth.instance.currentUser!.uid
    });
  } catch (e) {
    print(e);
  }
}

/**---------------------------important-------------------------------**/
// LoadingIndicator(
// indicatorType: Indicator.lineScale,
// colors: const [
// Colors.pink,
// Colors.yellowAccent,
// Colors.lightGreenAccent,
// Colors.blue,
// Colors.orange,
// ],
// strokeWidth: 1,
// backgroundColor: Colors.transparent,
// pathBackgroundColor: Colors.blue,
// ),
