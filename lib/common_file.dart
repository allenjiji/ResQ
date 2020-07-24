import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class LoggedUser with ChangeNotifier {
  String name;
  String phone;
  String password;
  Position location;
  bool isVolunteer;
  bool isLoggedin;

  login() async {
    print("Entered login()");
    var url = '';
    Map data = {};
  }

  getLocation() async {
    location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(location);
    ;
  }

  register(String phone, String pass, String name) async {
    print("entered register");
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = 'http://kresq.herokuapp.com/resq/userprofile/';
    String json = {
      "name": "$name",
      "phone": "$phone",
      "password": "$pass",
      "is_volunteer": "False",
      "lat": (location.latitude),
      "lon": (location.longitude)
    }.toString();
    Response response = await post(url, headers: headers, body: json);
    print("response got as ${response.body}");
  }
}

class Post with ChangeNotifier {
  String postId;
  String genre;
  String heading;
  String image;
  String description;
  String location;
  String phone;
  String user;
  String time;
  int votes;
}
