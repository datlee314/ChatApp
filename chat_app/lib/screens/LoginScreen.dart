import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ChatModel sourceChat;
  List<ChatModel> chatModels = [
    ChatModel(
      name: "Lê Tuấn Đạt",
      icon: "person.svg",
      isGroup: false,
      time: "4:00",
      currentMessage: "Hi am Đạt",
      id: 1,
    ),
    ChatModel(
      name: "Root",
      icon: "person.svg",
      isGroup: false,
      time: "10:00",
      currentMessage: "Hi am Root",
      id: 2,
    ),
    ChatModel(
      name: "Tony Stark",
      icon: "person.svg",
      isGroup: false,
      time: "12:00",
      currentMessage: "I am Iron Man",
      id: 3,
    ),
    ChatModel(
      name: "Steve Rogers",
      icon: "person.svg",
      isGroup: false,
      time: "12:00",
      currentMessage: "I am Captain America",
      id: 4,
    ),
    ChatModel(
      name: "Thanos",
      icon: "person.svg",
      isGroup: false,
      time: "12:00",
      currentMessage: "I want Infinity Gaunlty",
      id: 5,
    ),
    // ChatModel(
    //     name: "Avengers",
    //     icon: "groups.svg",
    //     isGroup: true,
    //     time: "14:00",
    //     currentMessage: "Hi everyone on this group"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chatModels.length,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  sourceChat = chatModels.removeAt(index);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => HomeScreen(
                                chatModels: chatModels,
                                sourChat: sourceChat,
                              )));
                },
                child: ButtonCard(
                  name: chatModels[index].name,
                  icon: Icons.person,
                ),
              )),
    );
  }
}
