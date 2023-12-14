import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:campbelldecor/screens/payment_screens/VerifyUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/color_util.dart';

class PaymentScreen extends StatefulWidget {
  final double price;
  final String id;
  final String name;
  PaymentScreen({required this.id, required this.price, required this.name});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String verificationId = '';
  String otp = '';
  bool isCodeSent = false;
  final TextEditingController _addressController = TextEditingController();
  String? selectedPaymentMethod;
  String userAddress = '';
  String userShippingAddress = '';
  Map<String, dynamic> data = Map();

  /**--------------------Retrieve User Address------------------------------**/
  Future<Map<String, dynamic>> retrieveUserAddress() async {
    DocumentSnapshot userSnapshote = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userSnapshote.exists) {
      Map<String, dynamic> data = userSnapshote.data() as Map<String, dynamic>;

      return {
        'userAddress': data['address'],
      };
    } else {
      return {};
    }
  }

  /**--------------------Retrieve User Shipping Address------------------------------**/
  Future<Map<String, dynamic>> getBookingData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('bookings');
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(widget.id).get();

    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;

      return {
        'address': data['address'],
        'date': data['date'],
        'eventDate': data['eventDate'],
        'name': data['name'],
        'amount': data['paymentAmount'],
      };
    } else {
      return {};
    }
  }

  /**--------------------Insert User Shipping Address------------------------------**/
  Map<String, dynamic> user = Map();

  /**--------------------Save to Booking ------------------------------**/

  void _addBooking() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.id)
        .update({'status': 'pending', 'paymentAmount': widget.price});
  }

  /**--------------------set User ------------------------------**/
  void setUser() async {
    user = await getUserData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    setUser();
    Map<String, dynamic> event =
        ({'name': widget.name, 'price': widget.price, 'date': DateTime.now()});
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Pay'),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 150.0,
                    ),
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: FutureBuilder<Map<String, dynamic>>(
                          future: retrieveUserAddress(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator());
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Billing Address : ',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 8, 8, 8.0),
                                    child: Text(
                                      '${snapshot.data?['userAddress']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shadowColor: Colors.black,
                            elevation: 8,
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 40,
                            ),
                            title: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Shiping Address",
                                ),
                              ),
                            ),
                            content: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Shipping Address',
                                hintText: 'Enter your address',
                                prefixIcon: const Icon(Icons.house),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK',
                                    style: TextStyle(fontSize: 16)),
                                onPressed: () async {
                                  if (_addressController.text.isNotEmpty) {
                                    final String newAddress =
                                        _addressController.text.trim();
                                    setState(() {
                                      updateData('bookings', widget.id,
                                          'address', newAddress);
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Enter your Shipping Address",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black);
                                  }
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 150.0,
                      ),
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(18.0),
                            child: FutureBuilder<Map<String, dynamic>>(
                                future: getBookingData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.data?['address'] ==
                                      null) {
                                    return FutureBuilder<Map<String, dynamic>>(
                                        future: retrieveUserAddress(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Shipping Address : ',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          18, 8, 8, 8),
                                                  child: Text(
                                                    '${snapshot.data?['userAddress']}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        });
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Shipping Address :',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 8, 8, 8),
                                          child: Text(
                                            '${snapshot.data?['address']}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Click to change',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summery : ',
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
                            child: Text(
                              'Total Amount : \$${widget.price}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(18, 4, 0, 0),
                            child: Text(
                              'Payment Amount : \$${widget.price}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        children: [
                          Text('Select Your Payments Method :',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      /** ------------- Paypal method--------------- **/
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 3,
                            color: Colors.lightBlue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: const Text(
                                'PayPal',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              leading: Radio<String>(
                                activeColor: Colors.pink,
                                value: 'paypal',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      /** ------------- Cash on Hand method--------------- **/
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 3,
                            color: Colors.lightBlue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: const Text(
                                'Cash On Hand',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              leading: Radio<String>(
                                activeColor: Colors.pink,
                                value: 'cash_on_hand',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              /** ------------- Cancel Button --------------- **/
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Material(
                  elevation: 28,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              hexStringtoColor("db4baa"),
                              hexStringtoColor("bc6dd0"),
                              hexStringtoColor("815ef4"),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
                        borderRadius: BorderRadius.circular(15)),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 28,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              /** ------------- Booking Button --------------- **/
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Material(
                  elevation: 28,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              hexStringtoColor("db4baa"),
                              hexStringtoColor("bc6dd0"),
                              hexStringtoColor("815ef4"),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
                        borderRadius: BorderRadius.circular(15)),
                    child: ElevatedButton(
                        onPressed: () {
                          double advance = widget.price.toDouble();
                          if (selectedPaymentMethod == 'paypal') {
                            Navigation(
                                context,
                                VerifyUser(
                                    eventName: data['name'],
                                    name: widget.name,
                                    id: widget.id,
                                    price: widget.price,
                                    advance: advance,
                                    eventDate: data['eventDate'],
                                    user: user,
                                    event: event));
                          } else if (selectedPaymentMethod == 'cash_on_hand') {
                            _addBooking();
                            sendNotificationForAdmin(
                                widget.id,
                                'Booking request',
                                'Your booking request has been received. We will notify you shortly with our response.',
                                data['name'],
                                widget.price,
                                data['eventDate'].toDate());
                            Navigator.of(context).pop();
                            Navigation(context, HomeScreen()).then((value) {
                              clearAllSharedPreferenceData();
                            });
                          } else {
                            showInformation(
                                context, "Please select prefer method");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 28,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Text(
                            "Pay",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
