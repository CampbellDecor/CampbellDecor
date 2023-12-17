import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import '../dash_board/account_details.dart';

class VerifyUser extends StatefulWidget {
  final String eventName;
  final String name;
  final String id;
  final double price;
  final double advance;
  final Timestamp eventDate;
  final Map<String, dynamic> user;
  final Map<String, dynamic> event;

  VerifyUser({
    required this.eventName,
    required this.name,
    required this.id,
    required this.price,
    required this.advance,
    required this.eventDate,
    required this.user,
    required this.event,
  });
  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  late UserModel _user;
  String verificationId = '';
  String? phNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  String otp = '';
  bool isCodeSent = false;
  late String userURL;
  Future<Map<String, dynamic>> _loadUserData() async {
    final User user = _auth.currentUser!;
    final UserModel? userData = await _firestoreService.getUserData(user.uid);

    _user = userData ??
        UserModel(
          id: '',
          name: 'Loading...',
          imgURL:
              'https://firebasestorage.googleapis.com/v0/b/campbelldecor-c2d1f.appspot.com'
              '/o/Users%2Fuser.png?alt=media&token=af8768f7-68e4-4961-892f-400eee8bae5d',
          email: '',
          address: '',
          phoneNo: '',
        );
    userURL = _user.imgURL;
    if (userData != null) {
      _user = userData;
      return {
        'name': _user.name,
        'email': _user.email,
        'phone': _user.phoneNo,
        'address': _user.address
      };
    } else {
      return {
        'name': "name",
        'email': "email",
        'phone': "phoneNo",
        'address': "address"
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify User'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  child: FutureBuilder(
                      future: _loadUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SingleChildScrollView(
                            child: Center(
                              child: Card(
                                elevation: 15.0,
                                margin: const EdgeInsets.all(20.0),
                                child: Container(
                                  color: Colors.white70.withOpacity(0.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20.0),
                                        Stack(
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
                                              child: ClipOval(
                                                child: userURL != null
                                                    ? Image.network(
                                                        userURL,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/campbelldecor-c2d1f.appspot.com/o/Users%2Fuser.png?alt=media&token=af8768f7-68e4-4961-892f-400eee8bae5d',
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            Profile(userURL),
                                          ],
                                        ),
                                        const SizedBox(height: 15.0),
                                        const Text(
                                          'Name:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          _user.name,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 20.0),
                                        const Text(
                                          'Mobile No:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          '*' * (_user.phoneNo.length - 4) +
                                              _user.phoneNo.substring(
                                                  _user.phoneNo.length - 4),
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Material(
                                          elevation: 28,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      hexStringtoColor(
                                                          "db4baa"),
                                                      hexStringtoColor(
                                                          "bc6dd0"),
                                                      hexStringtoColor(
                                                          "815ef4"),
                                                    ],
                                                    begin:
                                                        Alignment.bottomRight,
                                                    end: Alignment.topLeft),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                try {
                                                  verifyPhoneNumber(phNo!);
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        scrollable: true,
                                                        shadowColor:
                                                            Colors.black,
                                                        elevation: 18,
                                                        icon: const Icon(
                                                          Icons
                                                              .verified_user_outlined,
                                                          color: Colors.blue,
                                                          size: 40,
                                                        ),
                                                        title: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                                'OTP Verification'),
                                                          ),
                                                        ),
                                                        content: Container(
                                                          height: 400,
                                                          width: 380,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                imgContainer(
                                                                    'assets/images/otp.png',
                                                                    180,
                                                                    180),
                                                                TextField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .verified_outlined,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    labelText:
                                                                        "Enter OTP",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.9),
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .never,
                                                                    fillColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                30.0),
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                0,
                                                                            style:
                                                                                BorderStyle.none)),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  onChanged:
                                                                      (value) {
                                                                    otp = value;
                                                                  },
                                                                  cursorColor:
                                                                      Colors
                                                                          .white,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.9),
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 50,
                                                                  child: ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                            if (states.contains(MaterialState.pressed)) {
                                                                              return Colors.black26;
                                                                            }
                                                                            return Colors.white;
                                                                          }),
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular((30))),
                                                                          )),
                                                                      onPressed: () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        _verifyOTP();
                                                                      },
                                                                      child: Text(
                                                                        "VERIFY OTP",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black87,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 16),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } catch (e) {
                                                  print("Error : $e");
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 28,
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    'Send OTP',
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                  Transform.rotate(
                                                    angle:
                                                        -30 * (3.14159 / 180),
                                                    child: Icon(
                                                      Icons.send_outlined,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    verified(AuthCredential authResult) {}

    verificationFailed(authException) {
      print('Verification failed: $authException');
      if (authException.toString() ==
          "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
        showInformation(context,
            "Looks like you've made several attempts. Take a short break and try again later. Thank you!");
      } else {
        showInformation(context,
            "Apologies for the inconvenience. Please attempt again later.");
      }
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      setState(() {
        this.verificationId = verificationId;
        this.isCodeSent = true;
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      print('Verification timeout: $verificationId');
      showToast("Verification timeout,try again.");
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _verifyOTP() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        Navigation(
            context,
            UsePaypal(
                sandboxMode: true,
                clientId:
                    "AfzAtOt2yh5xa4AElQ2bj3QroOPekqjVd5fpMotR4og9IY3NrW4h1UXyrMnSzLvj19TpGBUDH_AMcTIt",
                secretKey:
                    "EArmmUGnSt4w6OBXCptMWmw7I6bxDbZigkync-WoQ7hNldWs2xvWsjrLiNWQQFY-eyLB0mqoS4CJyoRq",
                returnURL: "https://samplesite.com/return",
                cancelURL: "https://samplesite.com/cancel",
                transactions: [
                  {
                    "amount": {
                      "total": widget.advance,
                      "currency": "USD",
                      "details": {
                        "subtotal": widget.advance,
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    "item_list": {
                      "items": [
                        {
                          "name": widget.name,
                          "quantity": 1,
                          "price": widget.advance,
                          "currency": "USD"
                        }
                      ],
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  _addBooking();
                  _addPaymentHistory(widget.advance);
                  GeneratePDFInvoice(
                      widget.user, widget.event, widget.id, widget.price);
                  clearAllSharedPreferenceData();
                  sendNotificationForAdmin(
                          widget.id,
                          'Booking request',
                          'Your booking request has been received. We will notify you shortly with our response.',
                          widget.eventName,
                          widget.price,
                          widget.eventDate.toDate())
                      .then((value) async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await Navigator.popAndPushNamed(context, "/homescreen");
                  });
                  showToast("Payment successful.");
                  Navigation(context, HomeScreen());
                },
                onError: (error) {
                  print("onError: $error");
                },
                onCancel: (params) {
                  print('cancelled: $params');
                }));
      } else {
        print('User is null');
      }
    } catch (e) {
      print("Error: $e");
      if (e is FirebaseAuthException && e.code == 'provider-already-linked') {
        showInformation(
            context, "The email address is already in use by another account.");
      } else {
        showInformation(context, "An error occurred: $e");
      }
    }
  }

  void _addBooking() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.id)
        .update({'status': 'pending', 'paymentAmount': widget.price});
  }

  void _addPaymentHistory(double price) async {
    await FirebaseFirestore.instance
        .collection('paymentDBHistory')
        .doc(widget.id)
        .set({'price': price, 'dateTime': DateTime.now()});
  }
}
