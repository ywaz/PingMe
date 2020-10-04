import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pingMe/bloc/bloc.dart';
import 'package:pingMe/bloc/simple_bloc_observer.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:pingMe/bloc/message_states.dart';
import 'package:flutter/foundation.dart';

void main() async{
  SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Repository repository = Repository();
  runApp(PingMe(repository));
}

class PingMe extends StatelessWidget {

  Repository repository;
  PingMe( this.repository);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'PingeMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MessagesScreen(repository:
        repository,
      ),
    );
  }
}

class MessagesScreen extends StatefulWidget {
  Repository repository;
  MessagesScreen({@required repository})
      : assert(repository != null);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessageBloc _msgBloc;

  @override
  void initState() {
    _msgBloc = MessageBloc(repository: widget.repository);
    // TODO: implement initState
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();

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
                        child: Text(state.listMessages[index]), width: 50),
                  )
                : CircularProgressIndicator(),
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
