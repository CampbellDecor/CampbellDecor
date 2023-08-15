// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RetrieveSubCollectionDataScreen extends StatefulWidget {
//   @override
//   _RetrieveSubCollectionDataScreenState createState() =>
//       _RetrieveSubCollectionDataScreenState();
// }
//
// class _RetrieveSubCollectionDataScreenState
//     extends State<RetrieveSubCollectionDataScreen> {
//   List<Map<String, dynamic>> subCollectionData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     retrieveSubCollectionData();
//   }
//
//   Future<void> retrieveSubCollectionData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('bookings') // Replace with your parent collection name
//           .doc('n8lhZJ3Gm8tzrYAaqnuG') // Replace with your parent document ID
//           .collection('service') // Replace with your subcollection name
//           .get();
//
//       if (querySnapshot.size > 0) {
//         setState(() {
//           subCollectionData = querySnapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//         });
//       } else {
//         print('Subcollection is empty');
//       }
//     } catch (e) {
//       print('Error retrieving subcollection data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Retrieve Subcollection Data')),
//       body: ListView.builder(
//         itemCount: subCollectionData.length,
//         itemBuilder: (context, index) {
//           var subDoc = subCollectionData[index];
//           return ListTile(
//             title: Text(subDoc['name']),
//             subtitle: Text(subDoc['count']),
//           );
//         },
//       ),
//     );
//   }
// }
