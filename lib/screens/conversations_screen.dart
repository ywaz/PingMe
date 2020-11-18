import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/authentication_bloc.dart';
import 'package:pingMe/bloc/authentication_events.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:pingMe/screens/messages_screen.dart';
import 'package:pingMe/repository/user.dart' as userModel;

class ConversationsScreen extends StatelessWidget {
  static const String routeName = 'ConversationsScreen';
  final userModel.User user;

  ConversationsScreen(this.user) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: 'Welcome',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
          TextSpan(
              text: ' ${user.userName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
        ])),
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () => context.bloc<AuthBloc>()..add(AuthLogOut()))
        ],
      ),
      body: FutureBuilder(
          future: RepositoryProvider.of<Repository>(context)
              .retrieveConversationsContacts(user.userId),
          builder: (context, conversationsList) {
            if (conversationsList.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (conversationsList.connectionState ==
                ConnectionState.done) {
              if (conversationsList.data.length == 0) {
                return Center(child: Text('No Conversations found !'));
              } else {
                return ListView.builder(
                    itemCount: conversationsList.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 6,
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title:
                              Text(conversationsList.data[index]['receiverName']),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MessagesScreen(
                              receiverName: conversationsList.data[index]
                                  ['receiverName'],
                              conversationId: conversationsList.data[index]
                                  ['conversation'],
                            );
                          })),
                        ),
                      );
                    });
              }
            }
            return null;
          }),
    );
  }
}
