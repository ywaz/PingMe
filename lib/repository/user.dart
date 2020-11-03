import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show required;

class User extends Equatable {
  final String userName, userId, userEmail, userImageUrl;

  const User(
      {@required this.userId,
      @required this.userName,
      @required this.userEmail,
      this.userImageUrl})
      : assert(userId != null && userName != null && userEmail != null);

  // It's useful to define a static empty User so that we don't have to handle null Users and can always work with a concrete User object.
  static const empty = User(userEmail: '', userId: '', userName: '', userImageUrl: '');

  //override props getter in order to use class instances comparison using equatable
  @override
  List<dynamic> get props => [userId, userName, userEmail, userImageUrl];
}
