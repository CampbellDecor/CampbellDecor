import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import '../notifications/welcomeNotification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmpassTextController = TextEditingController();
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
                textField("Confirm Password", Icons.lock_outlined, true,
                    _confirmpassTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Phone Number", Icons.phone_outlined,
                    false, _phoneNoTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Your Address", Icons.home_outlined, false,
                    _addressTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableButton(
                  context,
                  false,
                  () async {
                    if (_userTextController.text.isNotEmpty &&
                        _emailTextController.text.isNotEmpty &&
                        _passwordTextController.text.isNotEmpty &&
                        _phoneNoTextController.text.isNotEmpty &&
                        _addressTextController.text.isNotEmpty) {
                      if (_passwordTextController.text ==
                          _confirmpassTextController.text) {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          insertUserData(
                              _userTextController.text,
                              _emailTextController.text,
                              _phoneNoTextController.text,
                              _addressTextController.text,
                              FirebaseAuth.instance.currentUser!.uid);
                          print("Create New Account");
                          Navigation(context, HomeScreen()).then((value) {
                            CreationNotificationService notificationService =
                                CreationNotificationService();
                            notificationService.showNotification(
                                title: 'Create Account',
                                body: 'Welcome ${_userTextController.text}');
                          });
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      } else {
                        showErrorAlert(context,
                            'Password and Confirm password not Matched ');
                        print('Password and Confirm password not Matched ');
                      }
                    } else {
                      showErrorAlert(context, 'Please Fill the All feilds ');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertUserData(
      String name, String email, String phoneNo, String address, String id) {
    collectionReference.doc(id).set({
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
    }).then((_) async {
      print('User data stored successfully');
      // NotificationService().showNotification(
      //     title: 'Account Opening',
      //     body: 'Wow You Success full create Account..');
      // final _firebaseMessaging = FirebaseMessaging.instance;
      // final fCMToken = await _firebaseMessaging.getToken();
    }).catchError((error) {
      print('Failed to store user data: $error');
    });
  }
}
