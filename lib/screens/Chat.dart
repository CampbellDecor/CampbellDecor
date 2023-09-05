// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
// import 'package:campbelldecor/screens/homescreen.dart';
//
// import 'bookings_screens/cart_screen.dart';
//
// final String uid = FirebaseAuth.instance.currentUser!.uid;
// final User? user = FirebaseAuth.instance.currentUser;
//
// class ChatPage extends StatelessWidget {
//   final CollectionReference messagesRef =
//       FirebaseFirestore.instance.collection('messages');
//   final TextEditingController textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Page'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.black,
//         elevation: 20,
//
//         //currentIndex: ,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home, // Replace this with the desired icon for the route
//               size: 40,
//             ),
//             label: 'Home', // The label for accessibility (optional)
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.chat, // Replace this with the desired icon for the route
//               size: 30,
//             ),
//             label: 'Chat', // The label for accessibility (optional)
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons
//                   .add_circle_outline, // Replace this with the desired icon for the route
//               size: 40,
//             ),
//             label: 'Events', // The label for accessibility (optional)
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons
//                   .shopping_cart, // Replace this with the desired icon for the route
//               size: 40,
//             ),
//             label: 'Cart', // The label for accessibility (optional)
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.search, // Replace this with the desired icon for the route
//               size: 40,
//             ),
//             label: 'Settings', // The label for accessibility (optional)
//           ),
//         ],
//         onTap: (index) {
//           // Handle navigation here based on the selected index
//           if (index == 0) {
//             _navigateToHome(context);
//           } else if (index == 1) {
//             _navigateToChat(context);
//           } else if (index == 2) {
//             _navigateToEvents(context);
//           } else if (index == 3) {
//             _navigateToCart(context);
//           } else {
//             _navigateToSearch(context);
//           }
//         },
//       ),
//       body: Column(
//         children: [
//           // ElevatedButton(
//           //     onPressed: () {
//           //       print(FirebaseAuth.instance.currentUser?.uid);
//           //     },
//           //     child: Text('Click')),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: messagesRef
//                   .orderBy('timestamp')
//                   .where('senderId',
//                       isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//
//                 List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     Map<String, dynamic> messageData =
//                         messages[index].data() as Map<String, dynamic>;
//                     String text = messageData['text'];
//                     String senderId = messageData['senderId'];
//                     String date = DateFormat.yMd()
//                         .format(messageData['timestamp'].toDate());
//                     String time = DateFormat.jm()
//                         .format(messageData['timestamp'].toDate());
//
//                     bool isCurrentUser =
//                         senderId == FirebaseAuth.instance.currentUser!.uid;
//
//                     return Padding(
//                       padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
//                       child: ListTile(
//                         /*shape: MaterialStateProperty.all<
//                             RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.circular(50.0),
//                             ),
//                            ),*/
//                         title: Text(text),
//                         subtitle: Text(isCurrentUser ? 'You' : senderId),
//                         trailing: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Text(date),
//                               Text(time),
//                             ],
//                           ),
//                         ),
//                         tileColor: isCurrentUser
//                             ? Colors.blue
//                             : null, // Highlight messages from the current user
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: textController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     // Add your logic to send messages here
//                     String messageText = textController.text;
//                     // Clear the text field
//                     textController.clear();
//                     // Add logic to send the message to Firestore
//                     sendMessage(messageText, "");
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void sendMessage(String messageText, String senderId) {
//     // Add your logic to send the message to Firestore
//     // Create a new document in the "messages" collection
//     messagesRef.add({
//       'text': messageText,
//       'senderId': FirebaseAuth
//           .instance.currentUser!.uid, // Change to the appropriate sender ID
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
// }
//
// void _navigateToEvents(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => EventsScreen()),
//   );
// }
//
// void _navigateToChat(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => ChatPage()),
//   );
// }
//
// void _navigateToHome(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => HomeScreen()),
//   );
// }
//
// void _navigateToCart(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => AddToCartScreen()),
//   );
// }
//
// void _navigateToSearch(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => ChatPage()),
//   );
// }
