import 'package:campbelldecor/screens/dash_board/viewer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable/reusable_methods.dart';
import '../reusable/reusable_widgets.dart';

class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String otp = '';
  bool isCodeSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // verifyPhoneNumber('773059185');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    shadowColor: Colors.black,
                    elevation: 8,
                    icon: const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('OTP Verification'),
                      ),
                    ),
                    content: Container(
                      height: 400,
                      width: 380,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            imgContainer('assets/images/otp.png', 200, 200),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.verified_outlined,
                                  color: Colors.black,
                                ),
                                labelText: "Enter OTP",
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontFamily: 'OpenSans',
                                ),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                fillColor: Colors.grey.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                otp = value;
                              },
                              cursorColor: Colors.white,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontFamily: 'OpenSans',
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.black26;
                                        }
                                        return Colors.white;
                                      }),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular((30))),
                                      )),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    _verifyOTP();
                                  },
                                  child: Text(
                                    "VERIFY OTP",
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  );
                },
              );
            },
            child: Text('click'),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    verified(AuthCredential authResult) {}

    verificationFailed(authException) {
      print('Verification failed: $authException');
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      setState(() {
        this.verificationId = verificationId;
        this.isCodeSent = true;
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      print('Verification timeout: $verificationId');
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '+94 $phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _verifyOTP() async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        Navigation(context, ViewerScreen());
      } else {
        print('User is null');
      }
    } catch (e) {
      if (e.toString() ==
          '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.') {
        showInformation(context,
            'We have blocked all requests from this device due to too many attempts. Try again later.');
      } else if (e.toString() ==
          '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
        showInformation(context,
            'The sms code has expired. Please re-send the verification code to try again.');
      }
    }
  }
}
