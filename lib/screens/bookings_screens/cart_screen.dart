import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:campbelldecor/screens/payment_screens/checkoutscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

class AddToCartScreen extends StatefulWidget {
  AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final _cart = FirebaseFirestore.instance
      .collection("bookings")
      .where('status', isEqualTo: 'cart')
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid);

  List<bool> _isChecked = [];
  bool _selectAll = false;

  _resetAndNavigateBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('amount');
    await prefs.remove('packageAmount');
    await prefs.remove('events');
    await prefs.remove('package');
    Navigator.of(context).pop();
    BottomNavigationForHome(context, HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _resetAndNavigateBack,
          ),
          title: const Text('My Carts'),
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
        body: Column(
          children: [
            StreamBuilder(
              stream: _cart.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                      child: ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          _isChecked.add(false);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CheckboxListTile(
                                  checkColor: Colors.blue.shade900,
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Adjust the radius as needed
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        documentSnapshot['name'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink),
                                      )),
                                      Text(
                                        DateFormat.yMd().format(
                                            documentSnapshot['date'].toDate()),
                                        style: TextStyle(
                                            color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      '\$${documentSnapshot['paymentAmount']}0',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  value: _isChecked[index],
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _isChecked[index] = newValue!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text('No data available'),
                    ),
                  );
                }
              },
            ),
            if (_isChecked.length > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      elevation: 18,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  hexStringtoColor("815ef4"),
                                  hexStringtoColor("bc6dd0"),
                                  hexStringtoColor("db4baa"),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: ElevatedButton(
                          onPressed: _deleteSelected,
                          style: ElevatedButton.styleFrom(
                            elevation: 18,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.delete_simple,
                                color: Colors.white,
                                size: 28,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 18,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  hexStringtoColor("db4baa"),
                                  hexStringtoColor("bc6dd0"),
                                  hexStringtoColor("815ef4"),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: ElevatedButton(
                          onPressed: () async {
                            double j = 0;
                            for (int i = _isChecked.length - 1; i >= 0; i--) {
                              j++;

                              if (_isChecked[i]) {
                                print(_isChecked[i]);
                                final documentSnapshot =
                                    (await _cart.get()).docs[i];
                                Navigation(context,
                                    CheckOutScreen(id: documentSnapshot.id));
                              }
                            }
                            print(" pinthu $j");
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 18,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              Text(
                                'Book',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
        bottomNavigationBar: bottom_Bar(context, 2));
  }

  Row SelectAll() {
    bool value = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _toggleSelectAll();
          },
          child: const Text(
            'Select All',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (int i = 0; i < _isChecked.length; i++) {
        _isChecked[i] = _selectAll;
      }
    });
  }

  void _deleteSelected() async {
    for (int i = _isChecked.length - 1; i >= 0; i--) {
      if (_isChecked[i]) {
        final documentSnapshot = (await _cart.get()).docs[i];
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(documentSnapshot.id)
            .delete();

        _isChecked.removeAt(i);
      }
    }
    setState(() {});
  }
}
