import 'package:flutter/foundation.dart' show required;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/message_events.dart';
import 'package:pingMe/bloc/message_states.dart';
import 'package:pingMe/repository/repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState>{

  final Repository  repository;
  List<dynamic> listOfMessages = [];
  
  MessageBloc({@required this.repository}):assert(repository!=null), super(MessageLoading()){
repository.receiveMessage('123456789', '987654321').listen((event){
      listOfMessages=event.docs;
      add(ReceiveMessage(userId: '123456789', receiverId: '987654321'));      
      });
    MessageLoaded(listMessages: listOfMessages);
  }
    
   
  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async*{

    if(event is SendMessage){
      yield MessageLoading();
      try{
        await repository.sendMessage(event.message, event.receiverId);
        yield MessageUploaded(message: event.message, receiverId: event.receiverId);
      }catch(_){
        yield MessageError();
      }
    }

    if(event is ReceiveMessage){
      try{
        yield MessageLoaded(listMessages: listOfMessages);
      }catch(_){
        yield MessageError();
      }
    }

  }
} 

