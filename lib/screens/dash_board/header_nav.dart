import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/dash_board/contactUs.dart';
import 'package:campbelldecor/screens/bookings_screens/booking_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/color_util.dart';
import 'aboutUs.dart';
import 'ToDoList.dart';
import 'account_details.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? email = FirebaseAuth.instance.currentUser?.email;
  late String name;
  late String imgURL;
  bool userDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    CollectionReference usersCollection =
        await FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userSnapshot =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> user = userSnapshot.data() as Map<String, dynamic>;
    setState(() {
      name = user['name'];
      imgURL = user['imgURL'];
      userDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Wrap(
        runSpacing: 14,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringtoColor("CB2893"),
                hexStringtoColor("9546C4"),
                hexStringtoColor("5E61F4")
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    child: userDataLoaded
                        ? ClipOval(
                            child: Image.network(
                              imgURL,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
            accountName: userDataLoaded ? Text(name) : Text('loading...'),
            accountEmail: Text(email!),
          ),
          ListTile(
            title: const Text('View Account'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              Navigation(context, ProfileScreen());
            },
          ),
          const Divider(
            height: 0.1,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            title: const Text('View Histroy'),
            leading: const Icon(Icons.history),
            onTap: () {
              Navigation(context, BookingScreen());
            },
          ),
          const Divider(
            height: 0.1,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            title: const Text('View To Do List'),
            leading: const Icon(Icons.list),
            onTap: () {
              Navigation(context, TodoListScreen());
            },
          ),
          const Divider(
            height: 0.1,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            title: const Text('About Us'),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigation(context, AboutUs());
            },
          ),
          const Divider(
            height: 0.1,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: const Icon(Icons.mail),
            onTap: () {
              Navigation(context, ContactUs());
            },
          ),
          const Divider(
            height: 0.1,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
