// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class BookingDetailsScreen extends StatelessWidget {
//   const BookingDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference ref =
//         FirebaseFirestore.instance.collection('users');
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       appBar: AppBar(
//         title: Text("My Booking Details"),
//       ),
//       body: StreamBuilder(
//         stream: ref.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//                 itemCount: streamSnapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final DocumentSnapshot documentSnapshot =
//                       streamSnapshot.data!.docs[index];
//                   return Card(
//                     margin: const EdgeInsets.all(10),
//                     color: const Color.fromARGB(50, 260, 250, 254),
//                     child: ListTile(
//                       title: Text(documentSnapshot['name']),
//                       subtitle: Text(documentSnapshot['phoneno'].toString()),
//                       onTap: () {},
//                     ),
//                   );
//                 });
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          List<DataRow> rows = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return DataRow(
              cells: [
                // DataCell(Text(data.length.toString())),
                DataCell(Text(data['name'])),
                DataCell(Text(data['paymentAmount'].toString())),
                DataCell(
                    Text(DateFormat.yMd().format(data['eventDate'].toDate()))),
                DataCell(Text(DateFormat.yMd().format(data['date']
                    .toDate()))), // Add more DataCell widgets for each field you want to display
              ],
            );
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                // DataColumn(label: Text('No')),
                DataColumn(label: Text('Events')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Event Date')),
                DataColumn(label: Text('Booking Date')),
                // Add more DataColumn widgets for each field you want to display
              ],
              rows: rows,
            ),
          );
        },
      ),
    );
  }
}
