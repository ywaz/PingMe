import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pingMe/repository/message.dart';

class Repository {
  Repository({@required FirebaseFirestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const collection = 'PingMeChats';

  Future<void> sendMessage(Message message, String receiverId) async {
    await _firestore
        .collection(collection)
        .doc('${message.userId}-$receiverId')
        .collection('chats')
        .add({
      'createdAt': Timestamp.now(),
      'userId': message.userId,
      'userName': message.userName,
      'userImage': message.userImage,
    });
  }

  Stream<List<Message>> receiveMessage() {
    return _firestore
        .collection(collection).snapshots()
        .map((snapshot) {
      return snapshot.docs.map((documentSnapshot) {
        print('extracted data is : ${documentSnapshot.data()}');
        Message.fromSnapshot(documentSnapshot);
      }).toList();
    });
  }

  deleteMessage(Message message, String receiverId, String docId) {
    _firestore
        .collection(collection)
        .doc('${message.userId}-$receiverId')
        .collection('chats')
        .doc(docId)
        .delete();
  }
}
