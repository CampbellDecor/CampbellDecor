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
        title: Text('Customer care'),
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
                return Container(
                  decoration:
                      BoxDecoration(color: Colors.blue.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: Colors.blue.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: _messageController,
                        decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade700,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          _sendMessage(_messageController.text);
                        },
                      ),
                    ),
                  ),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
        child: Material(
            elevation: 3,
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            )),
      ),
    );
  }
}
