import 'dart:async';

import 'package:flutter/foundation.dart' show required;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/message_events.dart';
import 'package:pingMe/bloc/message_states.dart';
import 'package:pingMe/repository/repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Repository repository;
  StreamSubscription _messagesStream;

  MessageBloc({@required this.repository})
      : assert(repository != null),
        super(MessageLoading());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is SendMessage) {
      yield MessageLoading();
      try {
        await repository.sendMessage(event.message, event.receiverId);
        yield MessageUploaded(
            message: event.message, receiverId: event.receiverId);
      } catch (_) {
        yield MessageError();
      }
    }

    if (event is ReceiveMessage) {
      
      try {
        
        print('fucking event is $event');
        _messagesStream = repository
            .receiveMessage()
            .listen((listOfMessages) {
          add(MessageReceived(listOfMessage: listOfMessages));
          
        });
        
      } catch (_) {
        yield MessageError();
      }
    } else if (event is MessageReceived) {
      yield MessageLoading();
      yield MessageLoaded(listMessages: event.listOfMessage);

    }
  }


//override close method to cancel stream subscription
  @override
  Future<void> close() {
      print('closing streamlistener');
    _messagesStream?.cancel();
    return super.close();
  }
}
