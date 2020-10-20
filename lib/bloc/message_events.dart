import 'package:equatable/equatable.dart';
import 'package:pingMe/repository/message.dart';
import 'package:flutter/foundation.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent([List props = const []]);

  @override
  List<dynamic> get props => [];
}


class SendMessage extends MessageEvent {
    final Message message;
  final String conversationId;
  SendMessage({@required this.message, @required this.conversationId})
      : assert(message != null && message.text.isNotEmpty && conversationId!=null),
        super([message, conversationId]);
}

class ReceiveMessage extends MessageEvent {
  final String conversationId;
  ReceiveMessage({@required this.conversationId}):assert(conversationId!=null),super([conversationId]);
}

class MessageReceived extends MessageEvent{
  final List<Message> listOfMessage;
  MessageReceived({@required this.listOfMessage}):assert(listOfMessage!=null),super([listOfMessage]);
}

class DeleteMessage extends MessageEvent {}

