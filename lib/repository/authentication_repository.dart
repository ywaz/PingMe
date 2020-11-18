import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show required;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingMe/repository/user.dart' as userModel;

class SignUpFailure implements Exception {}

class SignInFailure implements Exception {}

class LogOutFailure implements Exception {}

class SignUpUserRegisterationFailure implements Exception {}

class AuthenticationRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;  //Firestore is required here as we store each new user in the user database(id,username,email,photo)
  
  
  AuthenticationRepository({FirebaseAuth userAuth, FirebaseFirestore firestore})
      : _auth = userAuth ??
            FirebaseAuth
                .instance, _firestore=firestore?? FirebaseFirestore.instance; //initialize _auth if userAuth is not specified at class instanciation

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

  userModel.User get currentUser {
    return userModel.User(
      userId: _auth.currentUser.uid,
      userEmail: _auth.currentUser.email,
      userName: 'notYetHandled',
      userImageUrl: null,
      );
  }

  Future<void> signUp(
      {@required String email,
      @required String pwd,
      @required String userName}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pwd);
      await userCredential.user.updateProfile(displayName: userName);
  
    } on Exception catch(e){
      print(e);
      throw SignUpFailure();
    }
  }

  Future<void> addNewwUserToDB()async{
        
    try{
         //put the user in the users database 
      await _firestore.collection('PingMeUsers').doc(_auth.currentUser.uid).set({
        'userName': _auth.currentUser.displayName,
        'email': _auth.currentUser.email,
      });
    }on Exception catch(e){
      print(e);
    }

  }

  Future<void> signInwithEmail(
      {@required String email, @required String pwd}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      
    }on FirebaseAuthException catch(e){
      print(e);
      throw SignInFailure();
    } 
    on Exception {
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
