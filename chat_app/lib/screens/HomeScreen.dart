import 'package:chat_app/LoginAndRegister/login.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Pages/CallPage.dart';
import 'package:chat_app/Pages/CameraPage.dart';
import 'package:chat_app/Pages/ChatPage.dart';
import 'package:chat_app/Pages/SearchPage.dart';
import 'package:chat_app/Pages/StatusPage.dart';
import 'package:chat_app/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.chatModels, this.sourChat}) : super(key: key);
  final List<ChatModel> chatModels;
  final ChatModel sourChat;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Me"),
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: SearchPage()),
              icon: Icon(Icons.search)),
          PopupMenuButton<_MenuValues>(onSelected: (value) {
            switch (value) {
              case _MenuValues.Profile:
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => ProfileScreen()));
                break;
              case _MenuValues.Logout:
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) => LoginPage()));
                break;
            }
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("Invite a friend"),
                value: _MenuValues.inviteAFriend,
              ),
              PopupMenuItem(
                child: Text("Contacts"),
                value: _MenuValues.Contacts,
              ),
              PopupMenuItem(
                child: Text("Settings"),
                value: _MenuValues.Settings,
              ),
              PopupMenuItem(
                child: Text("Profile"),
                value: _MenuValues.Profile,
              ),
              PopupMenuItem(
                child: Text("Log Out"),
                value: _MenuValues.Logout,
              ),
            ];
          })
        ],
        bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                text: "CHATS",
              ),
              Tab(
                text: "STATUS",
              ),
              Tab(
                text: "CALLS",
              )
            ]),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraPage(),
          ChatPage(
            chatModels: widget.chatModels,
            sourChat: widget.sourChat,
          ),
          StatusPage(),
          CallPage(),
        ],
      ),
    );
  }
}

enum _MenuValues { inviteAFriend, Contacts, Settings, Profile, Logout }
