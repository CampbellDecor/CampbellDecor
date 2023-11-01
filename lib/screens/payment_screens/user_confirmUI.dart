import 'package:campbelldecor/screens/payment_screens/user_confirmation.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  String? verificationId;

  void _verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(phoneNumber);
  }

  void _signInWithOTP(String smsCode) async {
    final user = await _auth.signInWithOTP(verificationId!, smsCode);
    if (user != null) {
      // User successfully authenticated, store user data in Firestore.
      _auth.updateUserProfile(
          user.uid, 'John Doe', 'https://example.com/profile.jpg');
    } else {
      // Handle authentication failure.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth Example'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _verifyPhoneNumber(
                    '+94773059185'); // Replace with the phone number to verify
              },
              child: Text('Send OTP'),
            ),
            TextField(
              onChanged: (smsCode) {
                // Update the SMS code as the user enters it.
              },
            ),
            ElevatedButton(
              onPressed: () {
                _signInWithOTP('123456'); // Replace with the entered SMS code.
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
