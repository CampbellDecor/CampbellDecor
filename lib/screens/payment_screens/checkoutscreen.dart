import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

class CheckOutScreen extends StatefulWidget {
  String id;
  CheckOutScreen({required this.id});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            "Checkout",
          ),
        ]),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Text('Document not found.');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                var data = snapshot.data!.data();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SingleChildScrollView(
                    // axisDirection: AxisDirection.down
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        reuseContainerList('assets/images/logo2.png', 100, 100,
                            '${data!['name']}', data!['eventDate'].toDate()),
                        SizedBox(
                          height: 200,
                        ),
                        reusePaymentContainer(
                            widget.id, data!['paymentAmount'], context, () {})
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
