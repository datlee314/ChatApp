import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/CustomUI/ContactCard.dart';
import 'package:chat_app/CustomUI/NewContactCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/SuperModel.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:chat_app/screens/CreateGroup.dart';
import 'package:chat_app/screens/NewContact.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
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
              "Select Contact",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "256 contacts",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
      body: ListView.builder(
          itemCount: data.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => CreateGroup()));
                },
                child: ButtonCard(
                  icon: Icons.group,
                  name: "New group",
                ),
              );
            } else if (index == 1) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => NewContact(
                                url: "/profile/getOtherUsers",
                              )));
                },
                child: ButtonCard(
                  icon: Icons.person_add,
                  name: "New contact",
                ),
              );
            }
            return Column(
                children: data
                    .map(
                      (item) => NewContactCard(
                        profileModel: item,
                        netWorkHandelr: netWorkHandelr,
                      ),
                    )
                    .toList());
          }),
    );
  }
}
