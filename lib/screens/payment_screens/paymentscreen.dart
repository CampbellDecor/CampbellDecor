import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../utils/color_util.dart';

class PaymentScreen extends StatefulWidget {
  final double price;
  final String id;
  PaymentScreen({required this.id, required this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _addressController = TextEditingController();
  String? selectedPaymentMethod;
  String userAddress = '';
  String userShippingAddress = '';

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
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      gradient: LinearGradient(colors: [
                        Colors.blue.shade800,
                        Colors.red.shade400,
                        Colors.orange.shade400,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                              return Text(
                                'Billing Address : ${snapshot.data?['userAddress']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
                        gradient: LinearGradient(
                            colors: [
                              hexStringtoColor("5Ed1F4"),
                              hexStringtoColor("CB28ee"),
                              hexStringtoColor("9546d4"),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
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
                                            return Text(
                                              'Shipping Address : ${snapshot.data?['userAddress']} ',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }
                                        });
                                  } else {
                                    return Text(
                                      'Shipping Address : ${snapshot.data?['address']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    );
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Click to change',
                              style: TextStyle(color: Colors.white),
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
                      gradient: LinearGradient(colors: [
                        hexStringtoColor("5Ed1F4"),
                        hexStringtoColor("CB28ee"),
                        hexStringtoColor("9546d4"),
                      ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        'Total Amount : ${widget.price}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                  gradient: LinearGradient(colors: [
                    hexStringtoColor("5Ed1F4"),
                    hexStringtoColor("CB28ee"),
                    hexStringtoColor("9546d4"),
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft),
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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 3,
                            color: Colors.lightBlue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: const Text(
                                'PayPal',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              leading: Radio<String>(
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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 3,
                            color: Colors.lightBlue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: const Text(
                                'Cash On Hand',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              leading: Radio<String>(
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: Size(150, 55),
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                    onPressed: () {
                      double advance = ((widget.price.toDouble()) / 100) * 10;
                      if (selectedPaymentMethod == 'paypal') {
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
                                    "total": advance,
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": advance,
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                      "The payment transaction description.",
                                  // "payment_options": {
                                  //   "allowed_payment_method":
                                  //       "INSTANT_FUNDING_SOURCE"
                                  // },
                                  "item_list": {
                                    "items": [
                                      {
                                        "name": "A demo product",
                                        "quantity": 1,
                                        "price": advance,
                                        "currency": "USD"
                                      }
                                    ],

                                    // shipping address is not required though
                                    // "shipping_address": {
                                    //   "recipient_name": "Jane Foster",
                                    //   "line1": "Travis County",
                                    //   "line2": "",
                                    //   "city": "Austin",
                                    //   "country_code": "US",
                                    //   "postal_code": "73301",
                                    //   "phone": "+00000000",
                                    //   "state": "Texas"
                                    // },
                                  }
                                }
                              ],
                              note:
                                  "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                Map<String, dynamic> qrMap =
                                    getBookingData() as Map<String, dynamic>;
                                generateQRCode(qrMap);
                                _addBooking();
                                _addPaymentHistory(advance);
                                sendNotificationForAdmin(widget.id);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                                // sendNotification(widget.id);

                                // Fluttertoast.showToast(
                                //     msg: "Payment Success",
                                //     toastLength: Toast.LENGTH_LONG,
                                //     gravity: ToastGravity.BOTTOM,
                                //     backgroundColor: Colors.white,
                                //     textColor: Colors.black);
                              },
                              onError: (error) {
                                print("onError: $error");
                              },
                              onCancel: (params) {
                                print('cancelled: $params');
                              }),
                        ).then((value) {
                          clearAllSharedPreferenceData();
                        });
                      } else if (selectedPaymentMethod == 'cash_on_hand') {
                        _addBooking();

                        sendNotificationForAdmin(widget.id);
                        sendNotificationForAdmin(widget.id);
                        print('Id is : ${widget.id}');
                        Navigation(context, HomeScreen());
                        print('Cash on hand is Selected');
                      } else {
                        showInformation(context, "Please select prefer method");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: Size(150, 55),
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
            ])
          ]),
        ),
      ),
    );
  }

  /**--------------------Save to Booking ------------------------------**/

  void _addBooking() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.id)
        .update({'status': 'pending'});
  }

  void _addPaymentHistory(double price) async {
    await FirebaseFirestore.instance
        .collection('paymentDBHistory')
        .doc(widget.id)
        .set({'price': price, 'dateTime': DateTime.now()});
  }

  generateQRCode(Map<String, dynamic> data) {
    Fluttertoast.showToast(
        msg: data['name'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black);
    // return QrImageView(
    //   data: data['name'],
    //   version: QrVersions.auto,
    //   size: 200.0,
    // );
  }
}
