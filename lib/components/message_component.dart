import 'package:flutter/material.dart';

class MessageComponent extends StatelessWidget {
  final String message, sender;
  final bool isMe;

  MessageComponent(this.message, this.sender, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(color: Colors.white, fontSize: 15.0)),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30.0 : 0.0),
              bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(isMe ? 0.0 : 30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                "$message",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
