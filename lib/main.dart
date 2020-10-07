import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pingMe/bloc/bloc.dart';
import 'package:pingMe/bloc/message_events.dart';
import 'package:pingMe/bloc/simple_bloc_observer.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:pingMe/bloc/message_states.dart';
import 'package:flutter/foundation.dart';

import 'repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  runApp(
    RepositoryProvider(
      create: (_) => Repository(firestore: firestore),
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
      home: const MessagesScreen(),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (_) => MessageBloc(
        repository: context.repository<Repository>(),
      )..add(ReceiveMessage(userId: '123456789', receiverId: '987654321')),
      child: const Messages(),
    );
  }
}

class Messages extends StatefulWidget {
  const Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PingMe'),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, MessageState state) {
        return Column(children: [
          Flexible(
            flex: 9,
            child: (state is MessageLoaded)
                ? ListView.builder(
                    itemCount: state.listMessages.length,
                    itemBuilder: (context, index) => Container(
                        child: Text(state.listMessages[index].text), width: 50),
                  )
                : Center(child:CircularProgressIndicator()),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 100,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Ping'),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: () {})
              ]),
            ),
          )
        ]);
      }),
    );
  }
}
