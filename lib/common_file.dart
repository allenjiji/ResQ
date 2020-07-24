import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';


class User with ChangeNotifier{
  String name;
  String phone;
  String password;
  Position location;
  bool isVolunteer;
  bool isLoggedin;
  
}

class Post with ChangeNotifier{
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