// import 'package:campbelldecor/reusable/reusable_methods.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
//
// import '../../utils/color_util.dart';
//
// class PaypalPayScreen extends StatefulWidget {
//   const PaypalPayScreen({super.key});
//
//   @override
//   State<PaypalPayScreen> createState() => _PaypalPayScreenState();
// }
//
// class _PaypalPayScreenState extends State<PaypalPayScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payments through PayPal'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [
//               hexStringtoColor("CB2893"),
//               hexStringtoColor("9546C4"),
//               hexStringtoColor("5E61F4")
//             ], begin: Alignment.bottomRight, end: Alignment.topLeft),
//           ),
//         ),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigation(
//                 context,
//                 UsePaypal(
//                     sandboxMode: true,
//                     clientId:
//                         "AfzAtOt2yh5xa4AElQ2bj3QroOPekqjVd5fpMotR4og9IY3NrW4h1UXyrMnSzLvj19TpGBUDH_AMcTIt",
//                     secretKey:
//                         "EArmmUGnSt4w6OBXCptMWmw7I6bxDbZigkync-WoQ7hNldWs2xvWsjrLiNWQQFY-eyLB0mqoS4CJyoRq",
//                     returnURL: "https://samplesite.com/return",
//                     cancelURL: "https://samplesite.com/cancel",
//                     transactions: const [
//                       {
//                         "amount": {
//                           "total": 10,
//                           "currency": "USD",
//                           "details": {
//                             "subtotal": 10,
//                             "shipping": '0',
//                             "shipping_discount": 0
//                           }
//                         },
//                         "description": "The payment transaction description.",
//                         // "payment_options": {
//                         //   "allowed_payment_method":
//                         //       "INSTANT_FUNDING_SOURCE"
//                         // },
//                         "item_list": {
//                           "items": [
//                             {
//                               "name": "A demo product",
//                               "quantity": 1,
//                               "price": 10,
//                               "currency": "USD"
//                             }
//                           ],
//
//                           // shipping address is not required though
//                           // "shipping_address": {
//                           //   "recipient_name": "Jane Foster",
//                           //   "line1": "Travis County",
//                           //   "line2": "",
//                           //   "city": "Austin",
//                           //   "country_code": "US",
//                           //   "postal_code": "73301",
//                           //   "phone": "+00000000",
//                           //   "state": "Texas"
//                           // },
//                         }
//                       }
//                     ],
//                     note: "Contact us for any questions on your order.",
//                     onSuccess: (Map params) async {
//                       print("onSuccess: $params");
//                     },
//                     onError: (error) {
//                       print("onError: $error");
//                     },
//                     onCancel: (params) {
//                       print('cancelled: $params');
//                     }));
//           },
//           child: const Text("PayPal"),
//         ),
//       ),
//     );
//   }
// }
