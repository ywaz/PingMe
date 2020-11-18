
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/repository/authentication_repository.dart';

import 'package:pingMe/repository/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({@required this.message});

  @override
  Widget build(BuildContext context) {
 
    final String userId = context.repository<AuthenticationRepository>().currentUser.userId;

    return Row(
      mainAxisAlignment: userId==message.userId?MainAxisAlignment.end: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: userId==message.userId?Colors.deepOrange[50]:Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(7)
          ),
          child: Text(message.text, softWrap: true,),
          padding: const EdgeInsets.all(5),
        )
      ],
      
    );
  }
}