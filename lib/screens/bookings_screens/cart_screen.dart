import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCartScreen extends StatefulWidget {
  AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final _cart = FirebaseFirestore.instance
      .collection("addtocart")
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid);

  List<bool> _isChecked = [];
  bool _selectAll = false;
  _resetAndNavigateBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('amount');
    await prefs.remove('amount');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _resetAndNavigateBack,
        ),
        title: Text('My Carts'),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _cart.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return LimitedBox(
                  maxHeight: 700,
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
                            elevation: 3,
                            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            color: Color.fromARGB(100, 260, 250, 254),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckboxListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      documentSnapshot['name'],
                                      style: TextStyle(fontSize: 18),
                                    )),
                                    Text(
                                      DateFormat.yMd().format(
                                          documentSnapshot['date'].toDate()),
                                    ), // Custom trailing icon
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'Rs.${documentSnapshot['paymentAmount']}0',
                                    style: TextStyle(fontSize: 16),
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
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 45,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: _deleteSelected,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.redAccent), // Background color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Padding
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Border radius
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold), // Text style
                      ),
                    ),
                    child: Text('Delete'), // Button text
                  )),
              Container(
                  height: 45,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue), // Background color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Padding
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Border radius
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold), // Text style
                      ),
                    ),
                    child: Text('Book'), // Button text
                  )),
            ],
          )
        ],
      ),
    );
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
          child: Text(
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
            .collection('addtocart')
            .doc(documentSnapshot.id)
            .delete();

        _isChecked.removeAt(i);
      }
    }
    setState(() {});
  }
}
