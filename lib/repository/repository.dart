import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pingMe/repository/message.dart';

class Repository {
  Repository({@required FirebaseFirestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const collection = 'PingMeChats';

  Future<void> sendMessage(Message message, String conversationId) async {
    await _firestore
        .collection(collection)
        .doc('$conversationId')
        .collection('chats')
        .add({
      'text': message.text,
      'createdAt': message.createdAt.toString(),
      'userId': message.userId,
      'userName': message.userName,
      'userImage': message.userImage,
    });
  }

  Stream<List<Message>> receiveMessage(String conversationId) {
    return _firestore
        .collection(collection)
        .doc('$conversationId')
        .collection('chats').orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((documentSnapshot) {
        print('extracted data is : ${documentSnapshot.data()}');
        return Message.fromSnapshot(documentSnapshot);
      }).toList();
    });
  }

  deleteMessage(Message message, String receiverId, String docId) {
    _firestore
        .collection(collection)
        .doc('${message.userId}$receiverId')
        .collection('chats')
        .doc(docId)
        .delete();
  }

  Future<List<Map<String, String>>> retrieveConversationsContacts(String userId) async {
   
    List<Map<String, String>> conversationIds = [];
    QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
    querySnapshot.docs.forEach((element) {
      
      if (element.id.contains(userId)) {
        print(element.id);
        conversationIds.add({
          'receiver': element.id
              .split(userId)
              .firstWhere((element) => element.isNotEmpty),
          'conversation': element.id
        });
      }
    });

      print(conversationIds);
      return conversationIds;
    
  }
}
