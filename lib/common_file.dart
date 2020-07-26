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

  logout(BuildContext ctx) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      prefs.remove("phone");
      Navigator.of(ctx).pushReplacementNamed('/');


  }

  getLocation() async {
    location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(location);
    return location;
  }

  register(String phone, String pass, String name, BuildContext ctx,Position location) async {
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
  int postId;
  String name;
  String category;
  Position position;
  String genre;
  String heading;
  String image;
  String description;
  String location;
  String phone;
  String place;
  String district;
  bool isVoted;
  int votes;
  Post(
      {@required this.postId,
      @required this.position,
      this.name,
      this.genre,
      this.category,
      @required this.heading,
      @required this.description,
      this.image,
      this.district,
      this.place,
      @required this.isVoted,
      @required this.votes,
      @required this.phone,
      this.location});

  makePost(Post p) async {
    const url = 'http://kresq.herokuapp.com/resq/userpost/';
    Map map = {
      "heading": p.heading,
      "content": p.description,
      "contactphn": p.phone,
      "i": p.category,
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Response response = await put(
      url,
      headers: {
        'Authorization': 'Token $token',
        "Content-type": "application/json"
      },
    );
    int statusCode = response.statusCode;
    print("like --> $statusCode");
  }

  unlikepost(Post p) async {
    var url = 'http://kresq.herokuapp.com/resq/upvote/${p.postId}';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Response response = await delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        "Content-type": "application/json"
      },
    );
    int statusCode = response.statusCode;
    print("unlike --> $statusCode");
  }

  getFirstPosts() {
    print("Entered _getFirstPosts()");
    return getPosts('http://kresq.herokuapp.com/resq/userpost/');
  }

  getAnnouncements(){
    print("Entered _getAnnouncements()");
    return getPosts('http://kresq.herokuapp.com/resq/userpost/?isAnnouncement=True');
  }

  loadmore(String next) {
    print("Entered loadmore()");
    return getPosts(next);
  }

  //makePost() async {}

  getPosts(String url) async {
    print("Entered getpost()");
    Response response = await get(url);
    int statuscode = response.statusCode;
    //String response_body = response.body;
    //print(statuscode);
    //print(response);
    //print(response_body);
    return response;
  }
}