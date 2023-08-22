import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Column(
        children: [
          const Text('Pending Programs'),
          const SizedBox(
            height: 50,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('userID',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where('eventDate', isGreaterThanOrEqualTo: DateTime.now())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              List<DataRow> rows =
                  snapshot.data!.docs.asMap().entries.map((entry) {
                int rowIndex = entry.key;
                Map<String, dynamic> data =
                    entry.value.data() as Map<String, dynamic>;

                return DataRow(
                  cells: [
                    DataCell(Text((rowIndex + 1).toString())),
                    DataCell(Text(data['name'])),
                    DataCell(Text(data['paymentAmount'].toString())),
                    DataCell(Text(
                        DateFormat.yMd().format(data['eventDate'].toDate()))),
                    DataCell(
                        Text(DateFormat.yMd().format(data['date'].toDate()))),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                );
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Events')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Event Date')),
                    DataColumn(label: Text('Booking Date')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: rows,
                ),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          // Divider(),
          const Text('Old Programms'),
          const SizedBox(
            height: 50,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('userID',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where('eventDate', isLessThan: DateTime.now())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              List<DataRow> rows =
                  snapshot.data!.docs.asMap().entries.map((entry) {
                int rowIndex = entry.key;
                Map<String, dynamic> data =
                    entry.value.data() as Map<String, dynamic>;

                return DataRow(
                  cells: [
                    DataCell(Text((rowIndex + 1).toString())),
                    DataCell(Text(data['name'])),
                    DataCell(Text(data['paymentAmount'].toString())),
                    DataCell(Text(
                        DateFormat.yMd().format(data['eventDate'].toDate()))),
                    DataCell(
                        Text(DateFormat.yMd().format(data['date'].toDate()))),
                  ],
                );
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
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
        ],
      ),
    );
  }
}
