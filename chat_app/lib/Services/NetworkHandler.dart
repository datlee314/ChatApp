import 'dart:convert';

import 'package:chat_app/Model/SuperModel.dart';
import 'package:chat_app/Model/profileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetWorkHandelr {
  String baseurl = "http://192.168.1.15:5000";
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future get(String url) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    // /user/register
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future delete(String url) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    // /user/register
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<dynamic> post(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }

  NetworkImage getImage(String username) {
    String url = formater("/uploads//profileImage//$username.jpg");
    return NetworkImage(url);
  }

  Future<List<ProfileModel>> getuserList({String query}) async {
    String token = await storage.read(key: "token");
    String urlList = 'http://192.168.1.15:5000/profile/getOtherUsers';

    var data = [];

    List<ProfileModel> results = [];
    var url = Uri.parse(urlList);

    try {
      var response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        Map<String, dynamic> hashmap = json.decode(response.body);
        data = hashmap["data"];
        results = data.map((e) => ProfileModel.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.name.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }

    return results;
  }
}
