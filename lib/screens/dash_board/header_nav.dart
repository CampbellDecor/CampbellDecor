import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/dash_board/contactUs.dart';
import 'package:campbelldecor/screens/bookings_screens/booking_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  // @override
  // void initState() {
  //   Fluttertoast.showToast(
  //       msg: "Successfullly Run",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
  //       backgroundColor: Colors.white,
  //       textColor: Colors.black);
  //   super.initState();
  //   getUserName();
  // }

  String? email = FirebaseAuth.instance.currentUser?.email;
  late String name = 'loading..';
  String imgURL =
      'https://firebasestorage.googleapis.com/v0/b/campbelldecor-c2d1f.appspot.com/o/Users%2Fuser.png?alt=media&token=af8768f7-68e4-4961-892f-400eee8bae5d';

  Future<Map<String, dynamic>> getUserInfo() async {
    CollectionReference usersCollection =
        await FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userSnapshot =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    // name = (userSnapshot.data() as Map<String, dynamic>)['name'];
    // imgURL = (userSnapshot.data() as Map<String, dynamic>)['imgURL'];
    // Fluttertoast.showToast(
    //     msg: "hello name is $name",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black);
    return {
      'name': (userSnapshot.data() as Map<String, dynamic>)['name'],
      'imgURL': (userSnapshot.data() as Map<String, dynamic>)['imgURL']
    };
  }

  // Future<String> getUserName() async {
  //   CollectionReference usersCollection =
  //       await FirebaseFirestore.instance.collection('users');
  //   DocumentSnapshot userSnapshot =
  //       await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   name = (userSnapshot.data() as Map<String, dynamic>)['name'];
  //   return name;
  // }
  //
  // Future<String> getUserImgUrl() async {
  //   CollectionReference usersCollection =
  //       await FirebaseFirestore.instance.collection('users');
  //   DocumentSnapshot userSnapshot =
  //       await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   imgURL = (userSnapshot.data() as Map<String, dynamic>)['imgURL'];
  //   print(imgURL);
  //   return imgURL;
  // }

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
            accountName: FutureBuilder<Map<String, dynamic>>(
              future: getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                      'Loading...'); // Show a loading indicator while fetching data.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  name = snapshot.data!['name'];
                  imgURL = snapshot.data!['imgURL'];
                  return Text(name);
                }
              },
            ),
            // accountName: FutureBuilder<String>(
            //   future: get(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text('Loading...');
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       name = snapshot.data!;
            //       return Text(name);
            //     }
            //   },
            // ),
            accountEmail: Text(email!),
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
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: getUserInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          imgURL = snapshot.data!['imgURL'];
                          return ClipOval(
                            child: imgURL != null
                                ? Image.network(
                                    imgURL,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    imgURL,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                            // FutureBuilder<String>(
                            //   future: getUserImgUrl(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return CircularProgressIndicator();
                            //     } else {
                            //       imgURL = snapshot.data!;
                            //       return Image.network(
                            //         imgURL,
                            //         width: 150,
                            //         height: 150,
                            //         fit: BoxFit.cover,
                            //       );
                            //     }
                            //   },
                            // ),
                            /*************************************/
                            // FutureBuilder<Map<String, dynamic>>(
                            //         future: getUserInfo(),
                            //         builder: (context, snapshot) {
                            //           if (snapshot.connectionState ==
                            //               ConnectionState.waiting) {
                            //             return CircularProgressIndicator();
                            //           } else {
                            //             imgURL = snapshot.data!['imgURL'];
                            //             return ClipOval(
                            //               child: Image.network(
                            //                 imgURL,
                            //                 width: 150,
                            //                 height: 150,
                            //                 fit: BoxFit.cover,
                            //               ),
                            //             );
                            //           }
                            //         },
                            //       ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // otherAccountsPictures: [],
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
              Navigation(context, TodoListScreen());
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
