import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String num = '+940758923831';
  String otp = '';
  bool isCodeSent = false;

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    verified(AuthCredential authResult) {
      // Handle phone number verification automatically if possible
      // (e.g., user has previously signed in with the same phone number).
    }

    verificationFailed(authException) {
      // Handle verification failure (e.g., invalid number).
      print('Verification failed: $authException');
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      setState(() {
        this.verificationId = verificationId;
        this.isCodeSent = true;
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // Handle timeout here.
      print('Verification timeout: $verificationId');
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
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
        // OTP verification successful, handle the signed-in user here.
        print('User signed in: ${user.uid}');
      } else {
        // Handle the case where user is null.
        print('User is null');
      }
    } catch (e) {
      // Handle OTP verification failure.
      print('OTP verification failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  num = value;
                },
              ),
              SizedBox(height: 20),
              if (isCodeSent)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter OTP'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Store the OTP input.
                    otp = value;
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Start the OTP verification process.
                  _verifyPhoneNumber(num!);
                  print('User ID is ${_auth.currentUser!.uid}');
                  print(num);
                },
                child: Text('Send OTP'),
              ),
              SizedBox(height: 20),
              if (isCodeSent)
                ElevatedButton(
                  onPressed: () {
                    // Verify the entered OTP.
                    _verifyOTP();
                  },
                  child: Text('Verify OTP'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
