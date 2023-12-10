// Future<void> verifyPhoneNumber(String phoneNumber) async {
//   verified(AuthCredential authResult) {}
//
//   verificationFailed(authException) {
//     print('Verification failed: $authException');
//   }
//
//   codeSent(String verificationId, [int? forceResendingToken]) {
//     setState(() {
//       this.verificationId = verificationId;
//       this.isCodeSent = true;
//     });
//   }
//
//   codeAutoRetrievalTimeout(String verificationId) {
//     print('Verification timeout: $verificationId');
//   }
//
//   await _auth.verifyPhoneNumber(
//     phoneNumber: '+94 $phoneNumber',
//     timeout: const Duration(seconds: 60),
//     verificationCompleted: verified,
//     verificationFailed: verificationFailed,
//     codeSent: codeSent,
//     codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//   );
// }
//
// Future<void> _verifyOTP() async {
//   final AuthCredential credential = PhoneAuthProvider.credential(
//     verificationId: verificationId,
//     smsCode: otp,
//   );
//
//   try {
//     final UserCredential userCredential =
//         await _auth.signInWithCredential(credential);
//     final User? user = userCredential.user;
//     if (user != null) {
//       Navigation(
//         context,
//         UsePaypal(
//             sandboxMode: true,
//             clientId:
//                 "AfzAtOt2yh5xa4AElQ2bj3QroOPekqjVd5fpMotR4og9IY3NrW4h1UXyrMnSzLvj19TpGBUDH_AMcTIt",
//             secretKey:
//                 "EArmmUGnSt4w6OBXCptMWmw7I6bxDbZigkync-WoQ7hNldWs2xvWsjrLiNWQQFY-eyLB0mqoS4CJyoRq",
//             returnURL: "https://samplesite.com/return",
//             cancelURL: "https://samplesite.com/cancel",
//             transactions: [
//               {
//                 "amount": {
//                   "total": advance,
//                   "currency": "USD",
//                   "details": {
//                     "subtotal": advance,
//                     "shipping": '0',
//                     "shipping_discount": 0
//                   }
//                 },
//                 "description": "The payment transaction description.",
//                 // "payment_options": {
//                 //   "allowed_payment_method":
//                 //       "INSTANT_FUNDING_SOURCE"
//                 // },
//                 "item_list": {
//                   "items": [
//                     {
//                       "name": widget.name,
//                       "quantity": 1,
//                       "price": advance,
//                       "currency": "USD"
//                     }
//                   ],
//                 }
//               }
//             ],
//             note: "Contact us for any questions on your order.",
//             onSuccess: (Map params) async {
//               _addBooking();
//               _addPaymentHistory(advance);
//               GeneratePDFInvoice(user, event, widget.id, widget.price);
//               sendNotificationForAdmin(
//                   widget.id,
//                   'Booking request',
//                   'Your booking request has been received. We will notify you shortly with our response.',
//                   data['name'],
//                   widget.price,
//                   data['eventDate'].toDate());
//               Fluttertoast.showToast(
//                   msg: "Payment Success",
//                   toastLength: Toast.LENGTH_LONG,
//                   gravity: ToastGravity.BOTTOM,
//                   backgroundColor: Colors.white,
//                   textColor: Colors.black);
//             },
//             onError: (error) {
//               print("onError: $error");
//             },
//             onCancel: (params) {
//               print('cancelled: $params');
//             }),
//       ).then((value) {
//         clearAllSharedPreferenceData();
//       });
//     } else {
//       print('User is null');
//     }
//   } catch (e) {
//     if (e.toString() ==
//         '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.') {
//       showInformation(context,
//           'We have blocked all requests from this device due to too many attempts. Try again later.');
//     } else if (e.toString() ==
//         '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
//       showInformation(context,
//           'The sms code has expired. Please re-send the verification code to try again.');
//     }
//   }
// }
