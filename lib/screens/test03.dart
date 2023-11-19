import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPostsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Posts'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .where('userID', isEqualTo: user.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data found'),
            );
          } else {
            var userDocument = snapshot.data!.docs.first;
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(userDocument.id)
                  .collection('todo')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> postSnapshot) {
                if (!postSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: postSnapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> postData =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(postData['desc']),
                        subtitle: Text(postData['task']),
                      );
                    }).toList(),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
