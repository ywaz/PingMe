import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  String text;
  String userId;
  String userName;
  DateTime createdAt;
  String userImage;

  Message(
      {@required this.text,
      @required this.userId,
      @required this.userName,
      @required this.createdAt,
      this.userImage});

  static Message fromSnapshot(QueryDocumentSnapshot snapshot) {
    return Message(
        text: snapshot.data()['text'],
        userId: snapshot.data()['userId'],
        userName: snapshot.data()['userName'],
        createdAt: DateTime.tryParse(snapshot.data()['createdAt']) );
  }
}
