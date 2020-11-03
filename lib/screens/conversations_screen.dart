import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/repository/repository.dart';
import 'package:pingMe/screens/messages_screen.dart';

class ConversationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: RepositoryProvider.of<Repository>(context)
            .retrieveConversationsContacts('123456789'),
        builder: (context, conversationsList) {
          return conversationsList.connectionState == ConnectionState.done
              ? ListView.builder(
                  itemCount: conversationsList.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 6,
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(conversationsList.data[index]['receiver']),
                        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return MessagesScreen(conversationId: conversationsList.data[index]['conversation'], );
                        })),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
