import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Profile/OtherProfile.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewContactCard extends StatelessWidget {
  const NewContactCard({Key key, this.profileModel, this.netWorkHandelr})
      : super(key: key);
  final ProfileModel profileModel;
  final NetWorkHandelr netWorkHandelr;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 53,
        width: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetWorkHandelr().getImage(profileModel.username),
            ),
          ],
        ),
      ),
      title: Text(
        profileModel.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        profileModel.status,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
