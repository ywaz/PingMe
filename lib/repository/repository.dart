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
        .collection('chats')
        .orderBy('createdAt')
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

  Future<String> getUserfromDB(String userId) async {
    DocumentSnapshot documentSS =
        await _firestore.collection('PingMeUsers').doc(userId).get();

    if (documentSS.data()['email'] != null) {
      return documentSS.data()['email'];
    }
    return 'Unknown';
  }

  Future<List<Map<String, Object>>> retrieveConversationsContacts(
      String userId) async {
    print('retrieve conversations started...');
    List<Map<String, String>> conversationIds = [];

    QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
    querySnapshot.docs.forEach((element) {
      if (element.id.contains(userId)) {
        String receiverId = element.id.trim()
            .split(userId)
            .firstWhere((element) => element.isNotEmpty);

       conversationIds
            .add({'receiver': receiverId, 'conversation': element.id});
      }
    });

    for (Map<String, String> i in conversationIds) {
      print('toto:  ${i['receiver']}');
      DocumentSnapshot temp =
          await _firestore.collection('PingMeUsers').doc(i['receiver']).get();
          if(temp.exists){
            i.addAll({'receiverName': temp.data()['userName']});

          }
      
    }

    return conversationIds;
  }

  static registerUser(String email, String uID, String userName) {}
}
