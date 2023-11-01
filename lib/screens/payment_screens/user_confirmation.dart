import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verify phone number
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("Success");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("faild");
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store verificationId and show UI for entering OTP.
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout, consider resending the code.
      },
    );
  }

  // Verify OTP and sign in
  Future<User?> signInWithOTP(String verificationId, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      // Handle the error
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore functions to store user data
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserProfile(
      String uid, String displayName, String photoURL) async {
    return await usersCollection.doc(uid).set({
      'displayName': displayName,
      'photoURL': photoURL,
    });
  }
}
