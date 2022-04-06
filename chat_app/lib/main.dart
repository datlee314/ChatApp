import 'package:camera/camera.dart';
import 'package:chat_app/NewScreen/LandingScreen.dart';
import 'package:chat_app/screens/CameraScreen.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'LoginAndRegister/login.dart';
import 'LoginAndRegister/signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Profile/MainProfile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = LoginScreen();
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = LoginScreen();
      });
    } else {
      page = LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "OpenSans",
          primaryColor: Colors.blue[900],
          accentColor: Colors.blue),
      home: page,
    );
  }
}
