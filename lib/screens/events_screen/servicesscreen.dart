import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/bookings_screens/cart_screen.dart';
import 'package:campbelldecor/screens/events_screen/serviceselectscreen.dart';
import 'package:campbelldecor/screens/payment_screens/checkoutscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/color_util.dart';

class ServicesScreen extends StatefulWidget {
  final DateTime eventDate;
  ServicesScreen({required this.eventDate});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');
  //----------------------------------------
  Map<String, dynamic> data = {};
  Map<String, dynamic> myMap = {};
  double amount = 0;
  double? packageAmount;
  String? event;
  String? package;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  _resetAndNavigateBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('package');
    await prefs.remove('events');
    await prefs.remove('packageAmount');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print(_services.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _resetAndNavigateBack,
        ),
        title: Text('Our Services'),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: _services.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height * 0.82,
                        child: ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 10,
                                  child: Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          documentSnapshot['imgURL'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: ListTile(
                                            //----------------------Text Container background ----------------------//

                                            title: Container(
                                              height: 70,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                              //----------------------Text Editings----------------------//
                                              child: Text(
                                                documentSnapshot['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigation(
                                                  context,
                                                  ServiceSelectScreen(
                                                    map: data,
                                                    data: documentSnapshot[
                                                        'name'],
                                                    id: documentSnapshot.id,
                                                  ));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /**----------------------------------------Add to cart Button--------------------------------------------**/
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 8, 0, 8),
                        child: Material(
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
                              onPressed: () async {
                                try {
                                  /**--------------------- Add services into myMap ---------------------**/
                                  await getMapData('service').then((map) {
                                    setState(() {
                                      myMap = map;
                                    });
                                  });
                                  myMap.forEach((key, value) {
                                    if (key.endsWith('price')) {
                                      print('$key: $value');
                                      amount = (value + amount);
                                    }
                                  });

                                  /**---getFromSharedPreferences---**/
                                  packageAmount =
                                      await getDoubleData('packageAmount');
                                  event = await getData('event');
                                  package = await getData('package');

                                  /**---------------------insert Add to cart Collection---------------------**/
                                  if ((amount > 0) ||
                                      (packageAmount != null &&
                                          packageAmount! > 0)) {
                                    if (event != null) {
                                      await insertData(
                                              'bookings',
                                              event!,
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              amount,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        Navigation(context, AddToCartScreen())
                                            .then((value) {
                                          clearAllSharedPreferenceData();
                                        });
                                      });
                                    } else if (package != null) {
                                      await insertData(
                                              'bookings',
                                              package!,
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              packageAmount! + amount,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        Navigation(context, AddToCartScreen())
                                            .then((value) {
                                          clearAllSharedPreferenceData();
                                        });
                                      });
                                    } else {
                                      await insertData(
                                              'bookings',
                                              'Services Only',
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              amount,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        Navigation(context, AddToCartScreen())
                                            .then((value) {
                                          clearAllSharedPreferenceData();
                                        });
                                      });
                                    }
                                  } else {
                                    showInformation(
                                        context, 'Please Select Services');
                                  }
                                } catch (e) {}
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 18,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(CupertinoIcons.shopping_cart,
                                      color: Colors.white),
                                  Text(
                                    'Cart',
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
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      /**----------------------------------------Book Button--------------------------------------------**/
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 40, 8),
                        child: Material(
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
                                try {
                                  /**--------------------- Add services into myMap ---------------------**/
                                  await getMapData('service').then((map) {
                                    setState(() {
                                      myMap = map;
                                    });
                                  });
                                  myMap.forEach((key, value) {
                                    if (key.endsWith('price')) {
                                      print('$key: $value');
                                      amount = (value + amount);
                                    }
                                  });

                                  /**---getFromSharedPreferences---**/

                                  packageAmount =
                                      await getDoubleData('packageAmount');
                                  event = await getData('event');
                                  package = await getData('package');

                                  /**---------------------insert Booking Collection---------------------**/

                                  if ((amount > 0) ||
                                      (packageAmount != null &&
                                          packageAmount! > 0)) {
                                    if (event != null) {
                                      await insertData(
                                              'bookings',
                                              event!,
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              amount,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        final _book = FirebaseFirestore.instance
                                            .collection("bookings")
                                            .where('status', isEqualTo: 'cart')
                                            .where('eventDate',
                                                isEqualTo: widget.eventDate)
                                            .where('userID',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser?.uid);
                                        DocumentSnapshot documentSnapshot =
                                            (await _book.get()).docs[0];
                                        Navigation(
                                            context,
                                            CheckOutScreen(
                                                id: documentSnapshot.id));
                                      });
                                    } else if (package != null) {
                                      await insertData(
                                              'bookings',
                                              package!,
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              packageAmount!,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        final _book = FirebaseFirestore.instance
                                            .collection("bookings")
                                            .where('status', isEqualTo: 'cart')
                                            .where('eventDate',
                                                isEqualTo: widget.eventDate)
                                            .where('userID',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser?.uid);
                                        DocumentSnapshot documentSnapshot =
                                            (await _book.get()).docs[0];
                                        Navigation(
                                            context,
                                            CheckOutScreen(
                                                id: documentSnapshot.id));
                                      });
                                    } else {
                                      await insertData(
                                              'bookings',
                                              'Service Only',
                                              'cart',
                                              uid,
                                              DateTime.now(),
                                              widget.eventDate,
                                              amount,
                                              false,
                                              myMap)
                                          .then((value) async {
                                        final _book = await FirebaseFirestore
                                            .instance
                                            .collection("bookings")
                                            .where('status', isEqualTo: 'cart')
                                            .where('eventDate',
                                                isEqualTo: widget.eventDate)
                                            .where('userID',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser?.uid);
                                        DocumentSnapshot documentSnapshot =
                                            (await _book.get()).docs[0];
                                        Navigation(
                                            context,
                                            CheckOutScreen(
                                                id: documentSnapshot.id));
                                      });
                                    }
                                  } else {
                                    showInformation(
                                        context, 'Please Select Services');
                                  }
                                } catch (e) {
                                  print('Error $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 18,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.book_outlined,
                                      color: Colors.white),
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
