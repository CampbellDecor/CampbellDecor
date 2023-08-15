import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../reusable/reusable_methods.dart';

class PaymentScreen extends StatefulWidget {
  final double price;
  PaymentScreen({required this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod;
  String userAddress = '';
  late double amount;
  @override
  void initState() {
    super.initState();
    retrieveUserAddress();
  }

  Future<void> retrieveUserAddress() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        DocumentSnapshot userSnapshot = querySnapshot.docs.first;
        setState(() {
          userAddress = userSnapshot['address'];
        });
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error retrieving user address: $e');
    }
  }

  Future<double?> getDoubleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    amount = prefs.getDouble('amount')!;
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 260, 250, 254),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Billing Address : $userAddress',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 26, 200, 25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Offers : not Available ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 260, 25, 254),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total Amount : ${getDoubleData().toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text('Select Your Payments Method :',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text('Pay here'),
                              leading: Radio<String>(
                                value: 'Pay Here',
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text('Cash On Hand'),
                              leading: Radio<String>(
                                value: 'Cash On Hand',
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Make Payment'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
