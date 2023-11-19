import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/color_util.dart';

final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
final User? user = FirebaseAuth.instance.currentUser;

class TodoListScreen extends StatelessWidget {
  // final CollectionReference _messagesRef = FirebaseFirestore.instance
  //     .collection('bookings')
  //     .where('userID', isEqualTo: uid)
  //     .get();

  final TextEditingController textController = TextEditingController();

  Color getColorForStatus(String status) {
    switch (status) {
      case 'Not Started':
        return Colors.red.shade500;
      case 'In Progress':
        return Colors.yellow.shade500;
      case 'Completed':
        return Colors.green.shade500;
      default:
        return Colors.transparent;
    }
  }

  List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks) {
    tasks.sort((task1, task2) {
      final order = ['Not Started', 'In Progress', 'Completed'];
      final status1 = task1['status'];
      final status2 = task2['status'];
      return order.indexOf(status1).compareTo(order.indexOf(status2));
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .where('userID', isEqualTo: uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  try {
                    print(snapshot.data!.docs.toString());
                    print(snapshot.data!.docs.toString());
                    print(snapshot.data!.docs.toString());
                    print(snapshot.data!.docs.toString());
                    print(snapshot.data!.docs.toString());
                    List<QueryDocumentSnapshot> todolist = snapshot.data!.docs;
                    List<Map<String, dynamic>> tasks = todolist
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();
                    tasks = sortTasks(tasks);

                    return LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * 0.84,
                      child: ListView.builder(
                        itemCount: todolist.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> messageData = tasks[index];

                          String status = messageData['desc'] ?? '';
                          String taskName = messageData['task'] ?? '';
                          String userID = messageData['userID'] ?? '';

                          bool isCurrentUser =
                              userID == FirebaseAuth.instance.currentUser?.uid;

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(taskName),
                                  Text(
                                    isCurrentUser ? status : userID,
                                    style: TextStyle(
                                      color: Colors.indigo.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    // ...
                                    ),
                              ),
                              tileColor: getColorForStatus(status),
                            ),
                          );
                        },
                      ),
                    );
                  } catch (e) {
                    print(e);
                    return Text('pinthu');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
