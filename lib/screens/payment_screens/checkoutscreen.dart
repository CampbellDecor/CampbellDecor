import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

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
            "CheckOut",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            reuseContainerList("assets/images/logo2.png", 100, 100, "Wedding"),
            const SizedBox(
              height: 10,
            ),
            // reuseContainerList("assets/images/logo2.png", 100, 100, "Birthday"),
            const SizedBox(
              height: 120,
            ),

            reusePaymentContainer(5000, context, () {})
          ],
        ),
      ),
    );
  }
}
