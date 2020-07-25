import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:resq/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedUser with ChangeNotifier {
  String name;
  String phone;
  String password;
  Position location;
  bool isVolunteer;

  isLoggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stored_token = prefs.getString('token');
    if (stored_token == null) {
      return false;
    }
    return true;
  }

  login(BuildContext ctx) async {
    print("Entered login()");
    var url = 'http://kresq.herokuapp.com/resq/login/';
    Map map = {"username": phone, "password": password};
    var data = json.encode(map);
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: data);
    print("response got as ${response.body}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response_data = json.decode(response.body);
    prefs.setString('token', response_data["token"]);
    print("Checking");
    final String token = prefs.getString('token');
    print(token);
    if (token != null) {
      Navigator.of(ctx).pushReplacementNamed('/');
    }
  }

  getLocation() async {
    location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(location);
  }

  register(String phone, String pass, String name, BuildContext ctx) async {
    print("entered register $name");
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = 'http://kresq.herokuapp.com/resq/userprofile/';
    Map map = {
      "name": name,
      "phone": phone,
      "password": pass,
      "is_volunteer": "False",
      "lat": location.latitude.toStringAsFixed(5),
      "lon": location.longitude.toStringAsFixed(5)
    };
    var data = json.encode(map);
    Response response = await post(url, headers: headers, body: data);
    print("response got as ${response.body}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
    login(ctx);
  }
}

class Post with ChangeNotifier {
  String postId;
  String genre;
  Position position;
  String need;
  String heading;
  String image;
  String description;
  String location;
  String phone;
  String place;
  String district;

  makePost(Post p) async {
    const url = 'http://kresq.herokuapp.com/resq/userpost/';
    Map map = {
      "heading": p.heading,
      "content": p.description,
      "contactphn": p.phone,
      "lat": p.position.latitude.toStringAsFixed(5),
      "lon": p.position.longitude.toStringAsFixed(5)
    };
    var data = json.encode(map);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Response response = await post(url,
        headers: {
          'Authorization': 'Token $token',
          "Content-type": "application/json"
        },
        body: data);
    print(response.body);
  }

  likepost(Post p) async {
    var url = 'http://kresq.herokuapp.com/resq/upvote/${p.postId}';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await put(url, headers: headers);
    int statusCode = response.statusCode;
    print("like --> $statusCode");
  }

  unlikepost(Post p) async {
    var url = 'http://kresq.herokuapp.com/resq/upvote/${p.postId}';
    Response response = await delete(url);
    int statusCode = response.statusCode;
    print("unlike --> $statusCode");
  }
}
