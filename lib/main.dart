import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:pingMe/bloc/simple_bloc_observer.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:pingMe/screens/conversations_screen.dart';
import 'package:pingMe/screens/login_screen.dart';
import 'repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => Repository(firestore: firestore)),
        RepositoryProvider(create: (_)=> AuthenticationRepository(null))
      ],
      child: const PingMe(),
    ),
  );

}

class PingMe extends StatelessWidget {
  const PingMe({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingeMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
