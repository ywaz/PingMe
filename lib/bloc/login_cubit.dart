import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/login_state.dart';

import 'package:pingMe/models/form_validators.dart' as formValidators;
import 'package:pingMe/repository/authentication_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(AuthenticationRepository authenticationRepository)
      : assert(authenticationRepository != null),
        this._authenticationRepository = authenticationRepository,
        super(LoginState());

  void emailChanged(String email) {
    if (!formValidators.emailValidator(email)) {
      emit(EmailNeeded());
    } else {
      emit(ValidInput());
    }
  }

  void passwordChanged(String password) {
    if (!formValidators.passwordvalidator(password)) {
      emit(PWDNeeded());
    } else {
      emit(ValidInput());
    }
  }

  Future<void> signInWithEmail(String email, String pwd) async {
    try {
      emit(LoginRequested());
      await _authenticationRepository.signInwithEmail(email: email, pwd: pwd);
      emit(LoginSuccesfull());
    } on Exception {
      
      emit(LoginFailure());
    }
  }
}
