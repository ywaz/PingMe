import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/authentication_events.dart';
import 'package:pingMe/bloc/authentication_state.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/repository/user.dart' as userModel;

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<userModel.User> _userSubscription;

  AuthBloc(AuthenticationRepository authenticationRepository)
      : assert(authenticationRepository != null),
        this._authenticationRepository = authenticationRepository,
        super(UnAuthenticated()) {
    _userSubscription = _authenticationRepository.user.listen((user) {
  
      add(AuthUserChanged(user));
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is UnAuthenticated) {
      yield UnAuthenticated();
    } else if (event is AuthUserChanged && event.user!=userModel.User.empty) {
      //maybe add check on empty user here
      yield Authenticated(event.user);
    } else if (event is AuthLogOut){
      _authenticationRepository.logOut();
      yield(UnAuthenticated());
    }
 
  }

  @override
  Future<void> close() {
    print('closing auth subscription');
    _userSubscription?.cancel();
    return super.close();
  }
}
