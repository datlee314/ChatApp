import 'package:chat_app/CustomUI/customCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/screens/SelectContact.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key, this.chatModels, this.sourChat}) : super(key: key);
  final List<ChatModel> chatModels;
  final ChatModel sourChat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => SelectContact(
                        url: "/profile/getOtherUsers",
                      )));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chatModels.length,
        itemBuilder: (contex, index) => CustomCard(
          chatModel: widget.chatModels[index],
          sourChat: widget.sourChat,
        ),
      ),
    );
  }
}
