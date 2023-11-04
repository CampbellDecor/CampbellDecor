// import 'package:flutter/material.dart';
//
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});
//
//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }
//
// class _NotificationViewState extends State<NotificationView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notification Screen')),
//       body: listView(),
//     );
//   }
// }
//
// Widget listView() {
//   return ListView.separated(
//       itemBuilder: (context, index) {
//         return listViewItem(index);
//       },
//       separatorBuilder: (context, index) {
//         return const Divider(height: 0);
//       },
//       itemCount: 15);
// }
//
// Widget listViewItem(int index) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         preFixIcon(),
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 message(index),
//                 timeAndDate(index),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget preFixIcon() {
//   return Container(
//     height: 50,
//     width: 50,
//     padding: const EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       shape: BoxShape.rectangle,
//       color: Colors.cyanAccent[400],
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: const Icon(
//       Icons.notifications,
//       size: 20,
//       color: Colors.deepOrange,
//     ),
//   );
// }
//
// Widget message(int index) {
//   double textSize = 15;
//   return RichText(
//     maxLines: 3,
//     overflow: TextOverflow.ellipsis,
//     text: TextSpan(
//       text: 'Message',
//       style: TextStyle(
//           fontSize: textSize,
//           color: Colors.indigo,
//           fontWeight: FontWeight.bold),
//       children: const [
//         TextSpan(
//           // text: 'Notification Description',
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget timeAndDate(int index) {
//   return Container(
//     margin: const EdgeInsets.only(top: 5),
//     child: const Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           '13-08-2023',
//           style: TextStyle(
//             fontSize: 12,
//           ),
//         ),
//         Text(
//           '10-08-2023',
//           style: TextStyle(
//             fontSize: 12,
//           ),
//         ),
//       ],
//     ),
//   );
// }

/***-------------------Don't Open------------------------**/
