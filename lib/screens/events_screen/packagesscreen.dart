// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../reusable/reusable_methods.dart';
// // import '../filter_section/filter.dart';
//
// class PackageScreen extends StatefulWidget {
//   @override
//   _PackageScreenState createState() => _PackageScreenState();
// }
//
// class _PackageScreenState extends State<PackageScreen> {
//   final CollectionReference _packages =
//       FirebaseFirestore.instance.collection('packages');
//   // PackageFilter _currentFilter = PackageFilter();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       appBar: AppBar(
//         title: const Text(
//           "Packages",
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           // IconButton(
//           //   onPressed: () {
//           //     // Navigate to the filter screen and pass the current filter
//           //     Navigator.of(context).push(
//           //       MaterialPageRoute(
//           //         builder: (context) => FilterScreen(
//           //           packageFilter: _currentFilter,
//           //           applyFilters: () {
//           //             // Apply filters and update UI when the filter screen is closed
//           //             applyFilters();
//           //             Navigator.of(context).pop(); // Close the filter screen
//           //           },
//           //         ),
//           //       ),
//           //     );
//           //   },
//           //   icon: Icon(Icons.filter_alt),
//           // ),
//         ],
//       ),
//       body: Column(
//         children: [
//           StreamBuilder<QuerySnapshot>(
//             stream: _packages.snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//               if (streamSnapshot.hasData) {
//                 // Apply filters to the data here
//                 final filteredPackages = applyFiltersToPackages(
//                   streamSnapshot.data!.docs,
//                   _currentFilter, // Pass the current filter
//                 );
//
//                 return LimitedBox(
//                   maxHeight: 700,
//                   child: ListView.builder(
//                     itemCount: filteredPackages.length,
//                     itemBuilder: (context, index) {
//                       final DocumentSnapshot documentSnapshot =
//                           filteredPackages[index];
//                       return Padding(
//                         padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           elevation: 10,
//                           child: Container(
//                             height: 200,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               // image: DecorationImage(
//                               //   image: NetworkImage(
//                               //     documentSnapshot['imgURL'],
//                               //   ),
//                               //   fit: BoxFit.cover,
//                               // ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.black.withOpacity(0.2),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: ListTile(
//                                       //----------------------Text Container background ----------------------//
//
//                                       title: Container(
//                                         height: 70,
//                                         width: double.infinity,
//                                         alignment: Alignment.center,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           color: Colors.black.withOpacity(0.5),
//                                         ),
//                                         //----------------------Text Editings----------------------//
//                                         child: Text(
//                                           documentSnapshot['packageName'],
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 22,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         // SharedPreferences preferences =
//                                         // await SharedPreferences
//                                         //     .getInstance();
//                                         // preferences.setString('event',
//                                         //     documentSnapshot['packageName']);
//                                         // Navigation(context, CalendarScreen());
//                                       }),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to apply filters to packages
//   List<DocumentSnapshot> applyFiltersToPackages(
//     List<QueryDocumentSnapshot> packages,
//     PackageFilter filter,
//   ) {
//     var filteredPackages = packages;
//
//     // Apply event name filter
//     if (filter.eventName != null) {
//       filteredPackages = filteredPackages
//           .where((package) => package['packageName'] == filter.eventName)
//           .toList();
//     }
//
//     // Apply price range filter
//     if (filter.minPrice != null) {
//       filteredPackages = filteredPackages
//           .where((package) => package['price'] >= filter.minPrice!)
//           .toList();
//     }
//     if (filter.maxPrice != null) {
//       filteredPackages = filteredPackages
//           .where((package) => package['price'] <= filter.maxPrice!)
//           .toList();
//     }
//
//     // Apply rating range filter
//     if (filter.minRating != null) {
//       filteredPackages = filteredPackages
//           .where((package) => package['rating'] >= filter.minRating!)
//           .toList();
//     }
//     if (filter.maxRating != null) {
//       filteredPackages = filteredPackages
//           .where((package) => package['rating'] <= filter.maxRating!)
//           .toList();
//     }
//
//     // Apply order by
//     if (filter.ascendingOrder) {
//       filteredPackages.sort((a, b) => a['price'].compareTo(b['price']));
//     } else {
//       filteredPackages.sort((a, b) => b['price'].compareTo(a['price']));
//     }
//
//     return filteredPackages;
//   }
//
//   // Function to apply filters when filter screen is closed
//   void applyFilters() {
//     setState(() {
//       // This function will be called when the filter screen is closed.
//       //  filter criteria.
//     });
//   }
// }
