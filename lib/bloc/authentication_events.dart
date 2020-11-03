

import 'package:equatable/equatable.dart';

import 'package:pingMe/repository/user.dart' as userModel;

abstract class AuthenticationEvent extends Equatable{
  
  const AuthenticationEvent([List props = const[]]);

  @override
  List<dynamic> get props => [];
   
}

class AuthUserChanged extends AuthenticationEvent{
  final userModel.User user;
  AuthUserChanged(this.user):super([user]);
}

class AuthLogOut extends AuthenticationEvent{

}

