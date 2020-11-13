import 'package:equatable/equatable.dart';
import 'package:pingMe/models/form_validators.dart' as formz;

class SignUpState extends Equatable {
  final String userName, email, password;
  final formz.FormStatus status;

  SignUpState({this.userName='', this.email='', this.password='', this.status=formz.FormStatus.pure});

  List<dynamic> get props => [userName, email, password, status];

  SignUpState copyWith(
      {String userName,
      String email,
      String password,
      formz.FormStatus status}) {
    return SignUpState(
        email: email ?? this.email,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        status: status ?? this.status);
  }


}
