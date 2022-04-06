import 'dart:convert';

import 'package:chat_app/CustomUI/OwnFileCard.dart';
import 'package:chat_app/CustomUI/OwnMessageCard.dart';
import 'package:chat_app/CustomUI/ReplyCard.dart';
import 'package:chat_app/CustomUI/ReplyFIleCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/MessageModel.dart';
import 'package:chat_app/screens/CameraScreen.dart';
import 'package:chat_app/screens/CameraView.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  const IndividualPage({Key key, this.chatModel, this.sourChat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourChat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  IO.Socket socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ImagePicker _picker = ImagePicker();
  XFile file;
  int popTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  void connect() {
    socket = IO.io("http://192.168.1.15:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signin", widget.sourChat.id);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage(
          "destination",
          msg["message"],
          msg["path"],
        );
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
    print(socket.connected);
  }

  void sendMessage(String message, int sourceId, int targetId, String path) {
    setMessage("source", message, path);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "path": path
    });
  }

  void setMessage(String type, String message, String path) {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        path: path,
        time: DateTime.now().toString().substring(10, 16));
    print(message);

    setState(() {
      messages.add(messageModel);
    });
  }

  void onImageSend(String path, String message) async {
    print("hey there working $message");
    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.1.15:5000/routes/addImage"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print(data['path']);
    setMessage("source", message, path);
    socket.emit("message", {
      "message": message,
      "sourceId": widget.sourChat.id,
      "targetId": widget.chatModel.id,
      "path": path
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset("assets/group");
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage(
                        "assets/dl.jpg",
                      ),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel.name,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
                IconButton(onPressed: () {}, icon: Icon(Icons.call)),
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
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // //height: MediaQuery.of(context).size.height - 180,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (messages[index].type == "source") {
                          if (messages[index].path.length > 0) {
                            return OwnFileCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          } else {
                            return OwnMessageCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }
                        } else {
                          if (messages[index].path.length > 0) {
                            return ReplyFileCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          } else
                            return ReplyCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          Icons.emoji_emotions,
                                        ),
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (builder) =>
                                                        bottomSheet());
                                              },
                                              icon: Icon(Icons.attach_file)),
                                          IconButton(
                                              onPressed: () {
                                                popTime = 2;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CameraScreen(
                                                        onImageSend:
                                                            onImageSend,
                                                      ),
                                                    ));
                                              },
                                              icon: Icon(Icons.camera_alt)),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 5,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  child: IconButton(
                                    icon: Icon(
                                        sendButton ? Icons.send : Icons.mic),
                                    onPressed: () {
                                      if (sendButton) {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        sendMessage(
                                          _controller.text,
                                          widget.sourChat.id,
                                          widget.chatModel.id,
                                          "",
                                        );
                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo,
                      "Document", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                    () {
                      setState(() {
                        popTime = 3;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => CameraScreen(
                              onImageSend: onImageSend,
                            ),
                          ));
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                    Icons.insert_photo,
                    Colors.purple,
                    "Gallery",
                    () async {
                      setState(() {
                        popTime = 2;
                      });
                      file =
                          await _picker.pickImage(source: ImageSource.gallery);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CameraViewPage(
                                    path: file.path,
                                    onImageSend: onImageSend,
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      Icons.location_pin, Colors.teal, "Location", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact", () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          print(emoji);
          setState(() {
            _controller.text = _controller.text + emoji.emoji;
          });
        });
  }
}
