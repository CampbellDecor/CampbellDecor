import 'package:campbelldecor/resources/loader.dart';
import 'package:campbelldecor/screens/bookings_screens/date_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../reusable/reusable_methods.dart';

class ReligionSelectScreen extends StatefulWidget {
  @override
  _ReligionSelectScreenState createState() => _ReligionSelectScreenState();
}

class _ReligionSelectScreenState extends State<ReligionSelectScreen> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection('religions');
    return Scaffold(
      appBar: AppBar(
        title: Text('Religions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0.0),
                          child: Card(
                            // color: Colors.grey,
                            elevation: 8,
                            margin: const EdgeInsets.all(10),
                            // color: const Color.fromARGB(50, 260, 260, 254),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 120,
                                child: RadioListTile<String>(
                                  title: Center(
                                    child: Text(
                                      documentSnapshot['religion'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  value: documentSnapshot['religion'],
                                  groupValue: _selectedValue,
                                  activeColor: Colors.pink,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedValue = newValue;
                                    });
                                  },
                                  // splashRadius: Material.defaultSplashRadius,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  selected: _selectedValue ==
                                      documentSnapshot['religion'],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 20, 0, 50.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  splashFactory: InkRipple.splashFactory,
                ),
                // onPressed: () {
                //   if (_selectedValue != null) {
                //     Navigation(context, ServicesScreen());
                //   } else {
                //     showErrorAlert(context, 'Please Select One');
                //   }
                // },
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return PageLoader();
                    },
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    // Navigate to next page
                    Navigation(context, CalendarScreen());
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
