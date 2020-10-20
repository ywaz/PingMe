
import 'package:flutter/material.dart';

import 'package:pingMe/repository/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String userId;

  MessageBubble({@required this.userId, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: userId==message.userId?MainAxisAlignment.end: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(7)
          ),
          child: Text(message.text, softWrap: true,),
          padding: const EdgeInsets.all(5),
        )
      ],
      
    );
  }
}