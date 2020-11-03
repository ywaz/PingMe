import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show required;

import 'package:pingMe/repository/user.dart' as userModel;

class SignUpFailure implements Exception {}

class SignInFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  final FirebaseAuth _auth;
  AuthenticationRepository(FirebaseAuth userAuth)
      : _auth = userAuth ??
            FirebaseAuth
                .instance; //initialize _auth if userAuth is not specified at class instanciation

  Stream<userModel.User> get user {
    return _auth.userChanges().map((firebaseUser) {
      return firebaseUser == null
          ? userModel.User.empty
          : userModel.User(
              userEmail: firebaseUser.email,
              userId: firebaseUser.uid,
              userName: firebaseUser.displayName?? null,
              userImageUrl: firebaseUser.photoURL?? null);
    });
  }

  Future<void> signUp(
      {@required String email,
      @required String pwd,
      @required String userName}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pwd);
      await userCredential.user.updateProfile(displayName: userName);
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> signInwithEmail(
      {@required String email, @required String pwd}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } on Exception {
      throw SignInFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } on Exception {
      throw LogOutFailure();
    }
  }
}