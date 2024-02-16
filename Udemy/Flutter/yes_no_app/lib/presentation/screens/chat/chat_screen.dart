import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/friend_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/R.24b408e578bc433ddbf09aaf443d20ad?rik=Aj1GxRV4DfnBjw&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2f3%2f3a%2fGuinea_pig-Meerschweinchen.jpg&ehk=QB7qAzhFjomwu9pDeT4LprOrT3qEFgEOMA%2f%2f9GkBVHk%3d&risl=&pid=ImgRaw&r=0'),
          ),
        ),
        title: const Text('Cui cui'),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Expanded(child: ListView.builder(
            itemBuilder: (context, index) {
              return (index % 2 == 0
                  ? MyMessageBubble()
                  : FriendMessageBubble());
            },
          )),
          MessageFieldBox()
        ],
      ),
    ));
  }
}
