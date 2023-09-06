import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
final User? user = FirebaseAuth.instance.currentUser;

class TodoListScreen extends StatelessWidget {
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('todolist');
  final TextEditingController textController = TextEditingController();

  // String? get text => null;

  Color getColorForStatus(String status) {
    switch (status) {
      case 'Not Started':
        return Colors.red.shade500;
      case 'In Progress':
        return Colors.yellow.shade500;
      case 'Completed':
        return Colors.green.shade500;
      default:
        return Colors.transparent; // Default color if status doesn't match
    }
  }

  List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks) {
    // Custom order of statuses: Not Started -> In Progress -> Completed
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
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef
                  .orderBy('status')
                  .where('user_id',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<QueryDocumentSnapshot> todolist = snapshot.data!.docs;
                List<Map<String, dynamic>> tasks = todolist
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                tasks = sortTasks(tasks);
                return ListView.builder(
                  itemCount: todolist.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> messageData = tasks[index];

                    String status = messageData['status'] ?? '';
                    String taskName = messageData['taskName'] ?? '';
                    String user_id = messageData['user_id'] ?? '';

                    bool isCurrentUser =
                        user_id == FirebaseAuth.instance.currentUser?.uid;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(taskName),
                            Text(
                              isCurrentUser ? status : user_id,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
