import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/color_util.dart';

class UserChatScreen extends StatefulWidget {
  UserChatScreen({super.key});
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? userName;
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messages =
      FirebaseFirestore.instance.collection('messages');

  final CollectionReference _admins =
      FirebaseFirestore.instance.collection('admin');

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    User? user = _auth.currentUser;

    setState(() {
      _user = user;
    });
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    userName = userSnapshot.get('name');
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isNotEmpty) {
      await _messages.doc(_user!.uid).set({
        'userName': userName,
        'isUser': true,
        'senderId': _user!.uid,
      });
      await _messages.doc(_user!.uid).collection('message').add({
        'text': messageText,
        'userName': userName,
        'senderId': _user!.uid,
        'receiverId': 10,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Chat'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('message')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['senderId'];
                  var currentUser = _user!.uid;
                  var messageWidget = MessageWidget(
                    text: messageText,
                    isSentByUser: messageSender == currentUser,
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isSentByUser;

  MessageWidget({
    required this.text,
    required this.isSentByUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(text),
    );
  }
}
