

import 'package:equatable/equatable.dart';

class LoginState extends Equatable{

  LoginState([List props=const []]);

  List<dynamic> get props=>[];
}

class EmailNeeded extends LoginState{}

class PWDNeeded extends LoginState{}

class ValidInput extends LoginState{}

class LoginRequested extends LoginState{}

class LoginSuccesfull extends LoginState{}

class LoginFailure extends LoginState{}

