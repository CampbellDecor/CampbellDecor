import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/color_util.dart';

final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
final User? user = FirebaseAuth.instance.currentUser;

class TodoListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _bookingsRef =
      FirebaseFirestore.instance.collection('bookings');

  Color getColorForWork(String work) {
    switch (work) {
      case 'Not Started':
        return Colors.red.shade500.withOpacity(0.6);
      case 'In Progress':
        return Colors.yellow.shade500.withOpacity(0.6);
      case 'Completed':
        return Colors.green.shade500.withOpacity(0.6);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bookingsRef
            .orderBy('status')
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks available.'));
          }

          String bookingId = snapshot.data!.docs.first.id;

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('bookings')
                .doc(bookingId)
                .collection('todo')
                .snapshots(),
            builder: (context, todoSnapshot) {
              if (todoSnapshot.hasError) {
                return Center(child: Text('Error: ${todoSnapshot.error}'));
              }

              if (todoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!todoSnapshot.hasData || todoSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No tasks available in ToDo.'));
              }

              List<DocumentSnapshot> taskList = todoSnapshot.data!.docs;

              taskList.sort((task1, task2) {
                final statusOrder = {
                  'Not Started': 0,
                  'In Progress': 1,
                  'Completed': 2
                };
                final status1 = task1['status'] ?? '';
                final status2 = task2['status'] ?? '';
                return statusOrder[status1]!.compareTo(statusOrder[status2]!);
              });

              return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> taskData =
                      taskList[index].data() as Map<String, dynamic>;

                  String status = taskData['status'] ?? '';
                  String task = taskData['task'] ?? '';
                  String date = taskData['dueDate'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
                    child: ListTile(
                      title: Text(
                        task,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontFamily: "OpenSans"),
                      ),
                      subtitle: Text(
                        status,
                        style: TextStyle(
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      trailing: Text(date),
                      tileColor: getColorForWork(status),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
