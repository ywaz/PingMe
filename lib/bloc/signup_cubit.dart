import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/signup_state.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/models/form_validators.dart' as formz;

class SignUPCubit extends Cubit<SignUpState> {
  AuthenticationRepository _authenticationRepository;

  SignUPCubit(AuthenticationRepository authRepo)
      : assert(authRepo != null),
        _authenticationRepository = authRepo,
        super(SignUpState());

  void checkInput(String value, String input, [String validatedPwd]) {
    switch (input) {
      case 'email':
        if (!formz.emailValidator(value)) {
          emit(state.copyWith(
              email: value, status: formz.FormStatus.invalidEmail));
        } else {
          emit(state.copyWith(email: value, status: formz.FormStatus.validEmail));
        }
        break;
      case 'pwd':
        if (!formz.passwordvalidator(value)) {
          emit(state.copyWith(
              password: value, status: formz.FormStatus.invalidPwd));
        } else {
          emit(state.copyWith(password: value, status: formz.FormStatus.validPwd));
        }
        break;
      case 'pwdValidation':
        if (value == validatedPwd && validatedPwd.isNotEmpty) {
          emit(state.copyWith(status: formz.FormStatus.validPwdConfirmation));
        } else {
          emit(state.copyWith(status: formz.FormStatus.notMatching));
        }
        break;
      case 'userName':
        if (value.isEmpty) {
          emit(state.copyWith(
              userName: value, status: formz.FormStatus.emptyInput));
        } else {
          emit(state.copyWith(userName: value, status: formz.FormStatus.validuserName));
        }
        break;
      default:
        return;
    }
  }

  Future<void> createAccount(String email, String userName, String pwd) async {
    try {
      emit(state.copyWith(
          email: email,
          userName: userName,
          password: pwd,
          status: formz.FormStatus.signUpRequested));
      await _authenticationRepository.signUp(
          email: email, pwd: pwd, userName: userName);
      emit(state.copyWith(status: formz.FormStatus.signUpSuccesfull));
      await _authenticationRepository.addNewwUserToDB();
    } on Exception {
      print('signup failure occured');
      emit(state.copyWith(status: formz.FormStatus.signUpFailure));
    }
  }
}
