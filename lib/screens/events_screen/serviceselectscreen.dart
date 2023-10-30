import 'dart:convert';
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
      {required this.data, required this.map, required this.id});
  @override
  State<ServiceSelectScreen> createState() => _ServiceSelectScreenState();
}

class _ServiceSelectScreenState extends State<ServiceSelectScreen> {
  dynamic _selectedItem;
  double amount = 0;
  int count = 0;
  double? totalPrice;
  Map<String, double> items = Map();
  TextEditingController countController = TextEditingController(text: '0');
  TextEditingController priceController = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    print('Amount is $amount');
    print(totalPrice);
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              width: 300,
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
                    items.addAll({subDoc['name']: subDoc['price'].toDouble()});
                    // DropdownMenuItem(
                    //   value: subDoc['name'],
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(subDoc['name']),
                    //       Text('Rs.' + subDoc['price'].toString() + '.00'),
                    //     ],
                    //   ),
                    // ),
                  });

                  return DropdownButton(
                    hint: Text(
                      'Select ${widget.data}     ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    value: _selectedItem,
                    items: items.keys.map((String key) {
                      return DropdownMenuItem(
                        value: key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(key), Text('     Rs.${items[key]}0')],
                        ),
                      );
                    }).toList(),
                    onChanged: _onSelectedItemChanged,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              controller: countController,
              decoration: const InputDecoration(labelText: 'Enter Count'),
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
            const SizedBox(
              height: 50,
            ),
            TextField(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'Price'),
              readOnly: true,
              controller: priceController,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30.0, 30, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedItem = null;
                          countController.text = '0';
                          priceController.text = '0';
                        });
                      },
                      child: const Text('Clear')),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        amount = totalPrice!;
                        //---------------------------------------
                        if (amount > 0) {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          widget.map.addAll({
                            '${widget.data} service': _selectedItem,
                            '${_selectedItem} count': count,
                            '${_selectedItem} total price': 'Rs.${totalPrice}0'
                          });
                          String jsonData = json.encode(widget.map);
                          preferences.setString('service', jsonData);
                          preferences.setDouble('amount', amount);
                          print(totalPrice);
                          print('amount');
                          print(amount);
                          print('amount');
//---------------------------------------------------------------------------------------------
                          Navigator.pop(context);
                        } else {
                          showInformation(context, 'Please Select Service');
                        }
                      },
                      child: const Text('Confirm')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSelectedItemChanged(dynamic value) {
    setState(() {
      _selectedItem = value;
      print(_selectedItem);
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
