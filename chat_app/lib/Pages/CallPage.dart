import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          callCard(
            "Lê Tuấn Đạt",
            Icons.call_made,
            Colors.green,
            "July 18, 18:36",
          ),
          callCard(
            "Tony Stark",
            Icons.call_missed,
            Colors.red,
            "July 19, 18:36",
          ),
          callCard(
            "Hulk",
            Icons.call_received,
            Colors.green,
            "July 20, 18:36",
          ),
          callCard(
            "Lê Tuấn Đạt",
            Icons.call_made,
            Colors.green,
            "July 18, 18:36",
          ),
          callCard(
            "Tony Stark",
            Icons.call_missed,
            Colors.red,
            "July 19, 18:36",
          ),
          callCard(
            "Hulk",
            Icons.call_received,
            Colors.green,
            "July 20, 18:36",
          ),
          callCard(
            "Lê Tuấn Đạt",
            Icons.call_made,
            Colors.green,
            "July 18, 18:36",
          ),
          callCard(
            "Tony Stark",
            Icons.call_missed,
            Colors.red,
            "July 19, 18:36",
          ),
          callCard(
            "Hulk",
            Icons.call_received,
            Colors.green,
            "July 20, 18:36",
          ),
        ],
      ),
    );
  }

  Widget callCard(
      String name, IconData iconData, Color iconColor, String time) {
    return Card(
      margin: EdgeInsets.only(bottom: 0.5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/dl.jpg"),
          radius: 26,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              time,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        trailing: Icon(
          Icons.call,
          size: 28,
          color: Colors.teal,
        ),
      ),
    );
  }
}
