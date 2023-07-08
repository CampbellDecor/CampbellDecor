// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:campbelldecor/models/user_model.dart';
//
// class AuthMethods {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<String> registerUser({
//     required String username,
//     required String email,
//     required String password,
//     // required int phoneno,
//     required String address,
//   }) async {
//     String resp = "Some Error occured";
//     try {
//       if (username.isNotEmpty ||
//           email.isNotEmpty ||
//           password.isNotEmpty ||
//           address.isNotEmpty) {
//         UserCredential credential = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);
//
//         UserData userdata = UserData(
//           uid: credential.user!.uid,
//           username: username,
//           email: email,
//           password: password,
//           address: address,
//         );
//         await _firestore.collection('users').doc(credential.user!.uid).set(
//               userdata.toJson(),
//             );
//         resp = "success";
//       }
//     } catch (err) {
//       resp = err.toString();
//     }
//     return resp;
//   }
// }
