import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widgets.dart';
import '../utils/color_util.dart';
import 'homescreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNoTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign UP",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringtoColor("CD2B80"),
          hexStringtoColor("9546C4"),
          hexStringtoColor("5E40FA")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your UserName", Icons.person_outlined, false,
                    _userTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Email", Icons.person_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Phone Number", Icons.phone_outlined, true,
                    _phoneNoTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Address", Icons.home_outlined, true,
                    _addressTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    insertData(
                        _userTextController.text,
                        _emailTextController.text,
                        _phoneNoTextController.text,
                        _addressTextController.text);
                    print("Create New Account");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertData(String name, String email, String phoneNo, String address) {
    databaseReference.child('users').push();
    databaseReference.set({
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
    }).then((_) {
      print('User data stored successfully');
    }).catchError((error) {
      print('Failed to store user data: $error');
    });
  }
}
