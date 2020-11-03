

import 'package:equatable/equatable.dart';

import 'package:pingMe/repository/user.dart' as userModel ;

class AuthenticationState extends Equatable{

  AuthenticationState([List props=const []]);

  List<dynamic> get props=>[];
}

class Authenticated extends AuthenticationState{

  final userModel.User user;
  Authenticated(this.user):assert(user!=null && user!=userModel.User.empty), super([user]);

}

class UnAuthenticated extends AuthenticationState{
  UnAuthenticated({userModel.User user=userModel.User.empty}):super([userModel.User.empty]);
}


// ###########Bloc Firebase Login way to do it https://bloclibrary.dev/#/flutterfirebaselogintutorial?id=authentication-repository 
// enum AuthStatus {authenticated, unauthenticated, unknown}

// class AuthenticationState extends Equatable{

//   final userModel.User user;
//   final AuthStatus status;

//   const AuthenticationState._({this.status=AuthStatus.unknown, this.user=userModel.User.empty});

//   const AuthenticationState.unknown(): this._();

//   const AuthenticationState.unauthenticated() : this._(status: AuthStatus.unknown);

//   const AuthenticationState.authenticated(userModel.User user): this._(status: AuthStatus.authenticated, user:user);

//   List<dynamic> get props=>[status, user];
// }

