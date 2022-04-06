import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/CustomUI/ContactCard.dart';
import 'package:chat_app/CustomUI/NewContactCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/SuperModel.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Pages/SearchPage.dart';
import 'package:chat_app/Profile/OtherProfile.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';

class NewContact extends StatefulWidget {
  const NewContact({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  NetWorkHandelr netWorkHandelr = NetWorkHandelr();
  SuperModel superModel = SuperModel();
  List<ProfileModel> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await netWorkHandelr.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Contact",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "123 contacts",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: SearchPage()),
            icon: Icon(
              Icons.search,
              size: 26,
            ),
          ),
          PopupMenuButton<String>(onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("View contact"),
                value: "View contact",
              ),
              PopupMenuItem(
                child: Text("Media, links, and docs"),
                value: "Media, links, and docs",
              ),
              PopupMenuItem(
                child: Text("Chat Me Web"),
                value: "Chat Me Web",
              ),
              PopupMenuItem(
                child: Text("Search"),
                value: "Search",
              ),
              PopupMenuItem(
                child: Text("Wallpaper"),
                value: "Wallpaper",
              ),
            ];
          })
        ],
      ),
      body: Column(
          children: data
              .map(
                (item) => Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherProfile(
                                      profileModel: item,
                                      netWorkHandelr: netWorkHandelr,
                                    )));
                      },
                      child: NewContactCard(
                        profileModel: item,
                        netWorkHandelr: netWorkHandelr,
                      ),
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }
}
