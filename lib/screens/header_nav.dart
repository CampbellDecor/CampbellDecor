import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/ContactUs.dart';
import 'package:campbelldecor/screens/bookings_screens/booking_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'AboutUs.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                ;
                print(email!);
              },
              child: Text('Click')),
          UserAccountsDrawerHeader(
            accountName: Text('name'!),
            accountEmail: Text(email!),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset('assets/images/logo2.png'),
              ),
            ),
            otherAccountsPictures: [],
          ),
          ListTile(
            title: const Text('View Account'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyAboutUs()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
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
          ),
          ListTile(
            title: const Text('View To Do List'),
            leading: const Icon(Icons.list),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyToDoList()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
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
          )
        ],
      ),
    );
  }
}
