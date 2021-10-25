import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/message_component.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String messageText;
  final messageEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    messagesStream();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print("loggedInUser ${loggedInUser.email}");
      }
    } catch (e) {
      print("error getCurrentUser $e");
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection("messages").getDocuments();
    for (final message in messages.documents) {
      print("message ${message.data}");
    }
  }

  void messagesStream() async {
    await for (final snapshot
        in _firestore.collection("messages").snapshots()) {
      for (final message in snapshot.documents) {
        print("message stream ${message.data}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            messageStreamBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageEditingController.clear();
                      _firestore.collection("messages").add(
                          {"text": messageText, "sender": loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final List<MessageComponent> messageWidgets = [];
          for (final message in snapshot.data.documents.reversed) {
            final messageText = message.data["text"];
            final senderText = message.data["sender"];
            final currentUser = loggedInUser.email;

            messageWidgets.add(MessageComponent(messageText, senderText, currentUser == senderText));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          );
        }
      },
    );
  }
}
