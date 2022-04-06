import 'package:chat_app/Profile/CreateProfile.dart';
import 'package:chat_app/Profile/MainProfile.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetWorkHandelr networkHandler = NetWorkHandelr();
  Widget page = CircularProgressIndicator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    if (response["status"] == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }

  Widget showProfile() {
    return Center(child: Text("Profile Data is Avalable"));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap to button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => CreateProfile()))
            },
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Add Profile",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
