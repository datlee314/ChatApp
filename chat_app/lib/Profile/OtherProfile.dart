import 'package:chat_app/Model/FriendsModel.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Profile/CreateProfile.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:chat_app/screens/NewContact.dart';
import 'package:flutter/material.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key key, this.profileModel, this.netWorkHandelr})
      : super(key: key);
  final ProfileModel profileModel;
  final NetWorkHandelr netWorkHandelr;

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  NetWorkHandelr networkHandler = NetWorkHandelr();
  Widget page = CircularProgressIndicator();
  ProfileModel profileModel;
  FriendsModel friendsModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/friends/checkFriend/");
    if (response["status"] == true) {
      setState(() {
        page = cancelFriendRequest();
      });
    } else {
      setState(() {
        page = addFriend();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          head(),
          Divider(
            thickness: 0.8,
          ),
          otherDetails("Name", widget.profileModel.name),
          otherDetails("Profession", widget.profileModel.profession),
          otherDetails("Date of birth", widget.profileModel.DOB),
          otherDetails("Address", widget.profileModel.address),
          Divider(
            thickness: 0.8,
          ),
          InkWell(
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => CreateProfile()))
                  },
              child: page),
        ],
      ),
    );
  }

  Widget addFriend() {
    return InkWell(
      onTap: () async {
        Map<String, String> data = {
          "friendsname": widget.profileModel.name,
          "date": DateTime.now().toString().substring(10, 16),
        };
        var response = await networkHandler.post("/friends/Add", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      },
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Delete Friend",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget cancelFriendRequest() {
    return InkWell(
      onTap: () async {
        var response = await networkHandler.delete("/friends/delete/");
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      },
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Add Friend",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetWorkHandelr().getImage(widget.profileModel.username),
            ),
          ),
          Text(
            widget.profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(widget.profileModel.status)
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
