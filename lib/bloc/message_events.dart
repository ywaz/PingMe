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
  final String receiverId;
  SendMessage({@required this.message, @required this.receiverId})
      : assert(message != null && message.text.isNotEmpty && receiverId!=null),
        super([message, receiverId]);
}

class ReceiveMessage extends MessageEvent {
  final String userId, receiverId;
  ReceiveMessage({@required this.userId, @required this.receiverId}):assert(userId!=null && receiverId!=null),super([userId,receiverId]);
}

class MessageReceived extends MessageEvent{
  List<Message> listOfMessage;
  MessageReceived({@required this.listOfMessage}):assert(listOfMessage!=null),super([listOfMessage]);
}

class DeleteMessage extends MessageEvent {}

