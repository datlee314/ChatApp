import 'dart:io';

import 'package:chat_app/Services/NetworkHandler.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final networkHandler = NetWorkHandelr();
  bool circular = false;
  PickedFile _imageFile;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _status = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            professionTextField(),
            SizedBox(
              height: 20,
            ),
            dobTextField(),
            SizedBox(
              height: 20,
            ),
            addressTextField(),
            SizedBox(
              height: 20,
            ),
            statusTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalkey.currentState.validate()) {
                  Map<String, String> data = {
                    "name": _name.text,
                    "profession": _profession.text,
                    "DOB": _dob.text,
                    "address": _address.text,
                    "status": _status.text,
                  };
                  var response =
                      await networkHandler.post("/profile/add", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    if (_imageFile != null) {
                      var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image", _imageFile.path);
                      if (imageResponse.statusCode == 200) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/dl.jpg")
                : FileImage(File(_imageFile.path)),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.blueGrey,
                size: 28.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.blueGrey,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Lê Tuấn Đạt",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.work,
          color: Colors.blueGrey,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Full Stack Developer",
      ),
    );
  }

  Widget dobTextField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value.isEmpty) return "DOB can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.cake,
          color: Colors.blueGrey,
        ),
        labelText: "Date of birth",
        helperText: "Provide Date of birth on dd/mm/yyyy",
        hintText: "01/01/2022",
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      controller: _address,
      validator: (value) {
        if (value.isEmpty) return "address can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.home,
          color: Colors.blueGrey,
        ),
        labelText: "Address",
        helperText: "Address can't be empty",
        hintText: "Việt Nam",
      ),
    );
  }

  Widget statusTextField() {
    return TextFormField(
      controller: _status,
      validator: (value) {
        if (value.isEmpty) return "Status can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        labelText: "Status",
        helperText: "Write your status here",
        hintText: "Want be your sunshince",
      ),
    );
  }
}
