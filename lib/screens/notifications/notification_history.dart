import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../reusable/reusable_methods.dart';
import '../../utils/color_util.dart';
import 'notification_detail.dart';

class NotificationHistory extends StatefulWidget {
  @override
  _NotificationHistoryState createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  late Future<List<DocumentSnapshot>> data;
  bool isEditing = false;
  Set<String> selectedItems = Set<String>();

  Future<List<DocumentSnapshot>> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notification')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('dateTime', descending: true)
        .get();
    return querySnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
        actions: [
          isEditing
              ? IconButton(
                  onPressed: () {
                    _deleteSelected();
                    if (selectedItems.length <= 0) {
                      showToast("Please Select");
                    }
                  },
                  icon: Icon(Icons.delete_outline_outlined))
              : SizedBox(),
          isEditing
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                      selectedItems.clear();
                    });
                  },
                ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var document = snapshot.data![index];
                var documentId = document.id;
                Map<String, dynamic> Notifications =
                    document.data() as Map<String, dynamic>;
                Key cardKey = Key(documentId);

                return GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      setState(() {
                        if (selectedItems.contains(documentId)) {
                          selectedItems.remove(documentId);
                        } else {
                          selectedItems.add(documentId);
                        }
                      });
                    } else {
                      Navigation(
                          context,
                          NotificationDetailsScreen(
                            id: documentId,
                          ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Card(
                      elevation: 8,
                      key: cardKey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: isEditing && selectedItems.contains(documentId)
                          ? Colors.purple.withOpacity(0.5)
                          : Colors.white70.withOpacity(0.8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: 80,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          leading: Icon(
                            Icons.notification_important,
                            size: 35,
                          ),
                          iconColor: Colors.purpleAccent.shade200,
                          title: Text(
                            Notifications['head'],
                          ),
                          subtitle: Text(
                            shortenString(Notifications['body'], 45),
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(DateFormat.yMd().format(
                                    Notifications['dateTime'].toDate())),
                                Text(DateFormat.Hm().format(
                                    Notifications['dateTime'].toDate())),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _deleteSelected() async {
    for (int i = selectedItems.length - 1; i >= 0; i--) {
      if (selectedItems.elementAt(i) != 0) {
        print(selectedItems.elementAt(i));
        await FirebaseFirestore.instance
            .collection('notification')
            .doc(selectedItems.elementAt(i))
            .delete();
        setState(() {
          selectedItems.remove(i);
        });
      }
    }
  }
}
