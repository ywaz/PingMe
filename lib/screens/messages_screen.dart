import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pingMe/bloc/bloc.dart';
import 'package:pingMe/bloc/message_events.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/repository/message.dart';
import 'package:pingMe/bloc/message_states.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:pingMe/widgets/message_bubble.dart';

class MessagesScreen extends StatelessWidget {
  final String conversationId;
  const MessagesScreen({Key key, @required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (ctx) => MessageBloc(
        repository: ctx.repository<Repository>(),
      )..add(ReceiveMessage(conversationId: conversationId)),
      child: Messages(conversationId: this.conversationId),
    );
  }
}

class Messages extends StatefulWidget {
  final String conversationId;
  const Messages({Key key, @required this.conversationId}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PingMe'),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, MessageState state) {
        return Column(children: [
          Flexible(
            flex: 9,
            child: (state is MessageLoaded)
                ? ListView.builder(
                    itemCount: state.listMessages.length,
                    itemBuilder: (context, index) => MessageBubble(userId: context.repository<AuthenticationRepository>().currentUser.userId , message: state.listMessages[index]),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 100,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Ping'),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        print(DateTime.now());
                        BlocProvider.of<MessageBloc>(context).add(SendMessage(
                            message: Message(
                                text: _textController.text,
                                userId: context.repository<AuthenticationRepository>().currentUser.userId,
                                userName: 'toto',
                                createdAt: DateTime.now()),
                            conversationId: widget.conversationId));
                        _textController.clear();
                      }
                    })
              ]),
            ),
          )
        ]);
      }),
    );
  }
}
