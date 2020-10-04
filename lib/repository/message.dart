

import 'package:flutter/cupertino.dart';

class Message{

  String text;
  String userId;
  String userName;
  DateTime createdAt;
  String userImage;

  Message({@required this.text, @required this.userId, @required this.userName, @required this.createdAt, this.userImage});

}