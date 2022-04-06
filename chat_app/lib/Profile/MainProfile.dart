import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({Key key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetWorkHandelr networkHandler = NetWorkHandelr();
  ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (builder) => HomeScreen()));
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
      body: circular
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("Name", profileModel.name),
                otherDetails("Profession", profileModel.profession),
                otherDetails("Date of birth", profileModel.DOB),
                otherDetails("Address", profileModel.address),
                Divider(
                  thickness: 0.8,
                ),
              ],
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
              backgroundImage: NetWorkHandelr().getImage(profileModel.username),
            ),
          ),
          Text(
            profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.status)
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
