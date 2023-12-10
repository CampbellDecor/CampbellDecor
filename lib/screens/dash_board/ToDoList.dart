// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../utils/color_util.dart';
//
// final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
// final User? user = FirebaseAuth.instance.currentUser;
//
// class TodoListScreen extends StatelessWidget {
//   // final CollectionReference _messagesRef = FirebaseFirestore.instance
//   //     .collection('bookings')
//   //     .where('userID', isEqualTo: uid)
//   //     .get();
//
//   final TextEditingController textController = TextEditingController();
//
//   Color getColorForStatus(String status) {
//     switch (status) {
//       case 'Not Started':
//         return Colors.red.shade500;
//       case 'In Progress':
//         return Colors.yellow.shade500;
//       case 'Completed':
//         return Colors.green.shade500;
//       default:
//         return Colors.transparent;
//     }
//   }
//
//   List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks) {
//     tasks.sort((task1, task2) {
//       final order = ['Not Started', 'In Progress', 'Completed'];
//       final status1 = task1['status'];
//       final status2 = task2['status'];
//       return order.indexOf(status1).compareTo(order.indexOf(status2));
//     });
//
//     return tasks;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ToDo Page'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [
//               hexStringtoColor("CB2893"),
//               hexStringtoColor("9546C4"),
//               hexStringtoColor("5E61F4")
//             ], begin: Alignment.bottomRight, end: Alignment.topLeft),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('books')
//                   .where('userID', isEqualTo: uid)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   try {
//                     print(snapshot.data!.docs.toString());
//                     print(snapshot.data!.docs.toString());
//                     print(snapshot.data!.docs.toString());
//                     print(snapshot.data!.docs.toString());
//                     print(snapshot.data!.docs.toString());
//                     List<QueryDocumentSnapshot> todolist = snapshot.data!.docs;
//                     List<Map<String, dynamic>> tasks = todolist
//                         .map((doc) => doc.data() as Map<String, dynamic>)
//                         .toList();
//                     tasks = sortTasks(tasks);
//
//                     return LimitedBox(
//                       maxHeight: MediaQuery.of(context).size.height * 0.84,
//                       child: ListView.builder(
//                         itemCount: todolist.length,
//                         itemBuilder: (context, index) {
//                           Map<String, dynamic> messageData = tasks[index];
//
//                           String status = messageData['desc'] ?? '';
//                           String taskName = messageData['task'] ?? '';
//                           String userID = messageData['userID'] ?? '';
//
//                           bool isCurrentUser =
//                               userID == FirebaseAuth.instance.currentUser?.uid;
//
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
//                             child: ListTile(
//                               title: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(taskName),
//                                   Text(
//                                     isCurrentUser ? status : userID,
//                                     style: TextStyle(
//                                       color: Colors.indigo.shade700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               trailing: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                     // ...
//                                     ),
//                               ),
//                               tileColor: getColorForStatus(status),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } catch (e) {
//                     print(e);
//                     return Text('pinthu');
//                   }
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
        return Colors.red.shade500;
      case 'In Progress':
        return Colors.yellow.shade500;
      case 'Completed':
        return Colors.green.shade500;
      default:
        return Colors.transparent; // Default color if work doesn't match
    }
  }

  List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks) {
    // Custom order of works: Not Started -> In Progress -> Completed
    tasks.sort((task1, task2) {
      final order = ['Not Started', 'In Progress', 'Completed'];
      final work1 = task1['work'];
      final work2 = task2['work'];
      return order.indexOf(work1).compareTo(order.indexOf(work2));
    });

    return tasks;
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

          // Assuming there's only one booking for the current user
          // If multiple, you might need to adjust accordingly
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

              return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> taskData =
                      taskList[index].data() as Map<String, dynamic>;

                  String status = taskData['status'] ?? '';
                  String task = taskData['task'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
                    child: ListTile(
                      title: Text(task),
                      subtitle: Text(
                        status,
                        style: TextStyle(
                          color: Colors.indigo.shade700,
                        ),
                      ),
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
