import 'dart:convert';
import 'dart:ffi';
import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/color_util.dart';

class ServiceSelectScreen extends StatefulWidget {
  final String data;
  final String id;
  Map<String, dynamic> map;
  ServiceSelectScreen(
      {super.key, required this.data, required this.map, required this.id});
  @override
  State<ServiceSelectScreen> createState() => _ServiceSelectScreenState();
}

class _ServiceSelectScreenState extends State<ServiceSelectScreen> {
  dynamic _selectedItem;
  double amount = 0;
  int count = 0;
  double? totalPrice;
  late List<Double> total;
  Map<String, double> items = Map();
  TextEditingController countController = TextEditingController(text: '0');
  TextEditingController priceController = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Select Services",
        ),
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
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('services')
                          .doc(widget.id)
                          .collection(widget.data)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        snapshot.data?.docs.forEach((subDoc) {
                          items.addAll(
                              {subDoc['name']: subDoc['price'].toDouble()});
                        });

                        return Material(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DropdownButton(
                                alignment: AlignmentDirectional.center,
                                borderRadius: BorderRadius.circular(20),
                                hint: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Select ${widget.data}     ',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    ),
                                  ],
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                iconSize: 30,
                                elevation: 16,
                                style:
                                    TextStyle(color: Colors.pink, fontSize: 18),
                                value: _selectedItem,
                                items: items.keys.map((String key) {
                                  return DropdownMenuItem(
                                    value: key,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(key),
                                        Text('     \$${items[key]}0')
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: _onSelectedItemChanged,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white10.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          controller: countController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Count',
                          ),
                          onChanged: (value) {
                            setState(() {
                              count = int.tryParse(countController.text) ?? 0;
                            });
                            if (items.containsKey(_selectedItem)) {
                              _total(items[_selectedItem]!);
                            } else {
                              _total(0);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white10.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(labelText: 'Price'),
                          readOnly: true,
                          controller: priceController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30.0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                            elevation: 28,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        hexStringtoColor("815ef4"),
                                        hexStringtoColor("bc6dd0"),
                                        hexStringtoColor("db4baa"),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(15)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedItem = null;
                                      countController.text = '0';
                                      priceController.text = '0';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 18,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  )),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Material(
                          elevation: 28,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.34,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      hexStringtoColor("db4baa"),
                                      hexStringtoColor("bc6dd0"),
                                      hexStringtoColor("815ef4")
                                    ],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft),
                                borderRadius: BorderRadius.circular(15)),
                            child: ElevatedButton(
                                onPressed: () async {
                                  //---------------------------------------
                                  try {
                                    amount = totalPrice!;
                                    if (amount > 0) {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      widget.map.addAll({
                                        '${widget.data} service': _selectedItem,
                                        '${_selectedItem} count': count,
                                        '${_selectedItem} total price':
                                            totalPrice
                                      });

                                      String jsonData = json.encode(widget.map);
                                      preferences.setString(
                                          'service', jsonData);
                                      preferences.setDouble('amount', amount);
//---------------------------------------------------------------------------------------------
                                      Navigator.pop(context);
                                    } else {
                                      showInformation(
                                          context, 'Please Provide Count');
                                    }
                                  } catch (e) {
                                    showInformation(
                                        context, 'Please Select Services');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 18,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectedItemChanged(dynamic value) {
    setState(() {
      _selectedItem = value;
    });
    if (items.containsKey(value)) {
      _total(items[value]!);
    } else {
      _total(0);
    }
  }

/*--------------------------Total Amount Calculate------------------------------------*/
  void _total(double price) {
    totalPrice = (price * count);
    priceController.text = totalPrice.toString();
  }
}
