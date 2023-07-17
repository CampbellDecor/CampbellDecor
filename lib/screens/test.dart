// import 'package:campbelldecor/reusable_widgets/reusable_methods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ReligionSelectScreen extends StatefulWidget {
//   @override
//   _ReligionSelectScreenState createState() => _ReligionSelectScreenState();
// }
//
// class _ReligionSelectScreenState extends State<ReligionSelectScreen> {
//   List<bool> _selectedList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeSelectedList();
//   }
//
//   // Initialize SelectedList()
//   Future<void> _initializeSelectedList() async {
//     int documentCount = await getCollectionCount('religions');
//     setState(() {
//       _selectedList = List<bool>.filled(documentCount, false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference ref =
//         FirebaseFirestore.instance.collection('religions');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Religions'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: ref.snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//                 if (streamSnapshot.hasData) {
//                   return ListView.builder(
//                       itemCount: streamSnapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         final DocumentSnapshot documentSnapshot =
//                             streamSnapshot.data!.docs[index];
//                         return Padding(
//                           padding: const EdgeInsets.fromLTRB(30, 0, 30, 0.0),
//                           child: Card(
//                             color: _selectedList[index]
//                                 ? Color.fromARGB(80, 260, 260, 254)
//                                 : Color.fromARGB(35, 260, 260, 254),
//                             elevation: _selectedList[index] ? 5 : 8,
//                             margin: const EdgeInsets.all(10),
//                             // color: const Color.fromARGB(50, 260, 260, 254),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20),
//                               child: Container(
//                                 height: 120,
//                                 child: ListTile(
//                                   title: Text(
//                                     documentSnapshot['religion'],
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: _selectedList[index]
//                                           ? Colors.white
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedList[index] =
//                                           !_selectedList[index];
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       });
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
