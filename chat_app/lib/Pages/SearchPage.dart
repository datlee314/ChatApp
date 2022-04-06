import 'package:chat_app/CustomUI/NewContactCard.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:chat_app/Profile/OtherProfile.dart';
import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate {
  NetWorkHandelr netWorkHandelr = NetWorkHandelr();
  ProfileModel profileModel = ProfileModel();
  List<ProfileModel> data = [];

  List<String> recentSearch = [
    "Tha",
    "nos",
    "em",
    "lần",
    "này",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ProfileModel>>(
        future: netWorkHandelr.getuserList(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<ProfileModel> data = snapshot.data;
          return Column(
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
                  .toList());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: recentSearch.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recentSearch[index]),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {},
          );
        });
  }
}
