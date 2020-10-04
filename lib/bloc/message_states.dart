import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show required;
import 'package:pingMe/repository/message.dart';

abstract class MessageState extends Equatable {
  const MessageState([List props = const []]);

  @override
  List<dynamic> get props => [];
}

class MessageUploaded extends MessageState {
  final Message message;
  final String receiverId;
  MessageUploaded({@required this.message, @required this.receiverId})
      : assert(message != null && message.text.isNotEmpty && receiverId!=null),
        super([message, receiverId]);
}

class MessageLoading extends MessageState{}

class MessageLoaded extends MessageState {
  final List<dynamic> listMessages;
  MessageLoaded({@required this.listMessages})
      : assert(listMessages != null),
        super([listMessages]);
}

class MessageDeleted extends MessageState{
  final Message messageId;
  final String receiverId;
  final String docId;
  MessageDeleted(
      {@required this.messageId,
      @required this.receiverId,
      @required this.docId})
      : assert(messageId != null && receiverId != null && docId != null),
        super([messageId, receiverId, docId]);
}
class MessageError extends MessageState {}
