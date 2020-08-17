import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:resq/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedUser with ChangeNotifier {
  String id;
  String name;
  String phone;
  String password;
  Position location;
  bool isVolunteer;
  String district;
  String place;
  String address;
  String areaOfVolunteer;

  isLoggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stored_token = prefs.getString('token');
    if (stored_token == null) {
      return false;
    }
    return true;
  }

  login(BuildContext ctx, String phone, String password) async {
    print("Entered login()");
    var url = 'http://kresq.herokuapp.com/resq/login/';
    Map map = {"username": phone, "password": password};
    var data = json.encode(map);
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: data);
    print("response got as ${response.body}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response_data = json.decode(response.body);
    if (response.body !=
        '{"non_field_errors":["Unable to log in with provided credentials."]}') {
      prefs.setString('token', response_data["token"]);
      print("Checking");
      final String token = prefs.getString('token');
      print(token);
      prefs.setString('phone', phone);
      Response res = await get(
          'http://kresq.herokuapp.com/resq/userprofile/?phone=$phone');
      String name = json.decode(res.body)[0]["name"];
      print("name is name is ======>$name");
      prefs.setString('name', name);
      if (token != null) {
        Navigator.of(ctx).pushReplacementNamed('/');
        return 200;
      }
    }
    return 400;
  }

  logout(BuildContext ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("phone");
    prefs.remove("name");
    prefs.clear();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "LOGOUT",
              style: TextStyle(
                  fontSize: 20, color: Colors.red, fontStyle: FontStyle.normal),
            ),
            content: Text("Are you sure ?"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pushReplacementNamed('/'),
                  child: Text("YES")),
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(), child: Text("NO")),
            ],
          );
        });
  }

  getLocation() async {
    location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(location);
    return location;
  }

  register(String phone, String pass, String name, BuildContext ctx,
      Position location) async {
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
    return response;
    login(ctx, phone, pass);
  }

  makeVolunteer(LoggedUser user) async {
    //var res = getUserid(user);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user.phone = prefs.getString('phone');
    print(user.phone);
    Response res = await getUserid(user);
    //print(json.decode(res.body)["id"]);
    var a = (json.decode(res.body));
    user.id = (a[0]["id"].toString());
    String url = 'http://kresq.herokuapp.com/resq/userprofile/${user.id}/';

    final String token = prefs.getString('token');
    Map map = {
      'is_volunteer': "True",
      'district': user.district,
      'areaofvol': user.areaOfVolunteer,
      'address': user.address
    };
    var data = json.encode(map);
    Response response = await patch(url,
        headers: {
          'Authorization': 'Token $token',
          "Content-type": "application/json"
        },
        body: data);
    print(response.body);
  }

  unmakeVolunteer(LoggedUser user) async {
    //var res = getUserid(user);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user.phone = prefs.getString('phone');
    print(user.phone);
    Response res = await getUserid(user);
    //print(json.decode(res.body)["id"]);
    var a = (json.decode(res.body));
    user.id = (a[0]["id"].toString());
    String url = 'http://kresq.herokuapp.com/resq/userprofile/${user.id}/';

    final String token = prefs.getString('token');
    Map map = {
      'is_volunteer': "False",
    };
    var data = json.encode(map);
    Response response = await patch(url,
        headers: {
          'Authorization': 'Token $token',
          "Content-type": "application/json"
        },
        body: data);
    print(response.body);
  }

  getProfile(LoggedUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phone = prefs.getString('phone');
    String url = 'http://kresq.herokuapp.com/resq/userprofile/${user.id}/';
    Response response = await get(url);
    print(response.body);
    return response;
  }

  getUserid(LoggedUser user) async {
    String url =
        'http://kresq.herokuapp.com/resq/userprofile/?phone=${user.phone}';
    Response response = await get(url);
    print(response.body);
    return response;
  }

  getSavedUserPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String phone = prefs.getString('phone');
    print(phone);
    print(token);
    return phone;
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
  String userProfile;
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

  getMyPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phone = prefs.getString('phone');
    String url1 = 'http://kresq.herokuapp.com/resq/userprofile/?phone=$phone';
    Response response1 = await get(url1);
    //print(json.decode(response1.body)[0]["id"]);
    var id = json.decode(response1.body)[0]["id"];
    String url = 'http://kresq.herokuapp.com/resq/userpost/?userprofile=$id';
    Response response = await get(url);
    print(response.body);
    return response;
  }

  makePost(Post p) async {
    const url = 'http://kresq.herokuapp.com/resq/userpost/';
    String isRequest = "no";
    String isDonate = "no";
    String isAnnouncement = "no";
    String isFoodWater = "no";
    String isOther = "no";
    String isToiletries = "no";
    String isRescue = "no";
    switch (p.genre) {
      case "food":
        isFoodWater = "yes";
        break;
      case "water":
        isFoodWater = "yes";
        break;
      case "toiletries":
        isToiletries = "yes";
        break;
      case "rescue":
        isRescue = "yes";
        break;
      case "others":
        isOther = "yes";
        break;
      default:
    }
    print("p.category is ${p.category}");
    switch (p.category) {
      case "request":
        isRequest = "yes";
        break;
      case "donate":
        isDonate = "yes";
        break;
      case "announcement":
        isAnnouncement = "yes";
        break;
      default:
    }
    Map map = {
      "heading": p.heading,
      "content": p.description,
      "contactphn": p.phone,
      //"i": p.category,
      "lat": p.position.latitude.toStringAsFixed(5),
      "lon": p.position.longitude.toStringAsFixed(5),
      "isAnnouncement": isAnnouncement,
      "isRequest": isRequest,
      "isDonate": isDonate,
      "isToiletries": isToiletries,
      "isRescue": isRescue,
      "isFoodWater": isFoodWater,
      "isOther": isOther
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

  deletepost(Post p) async {
    String id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String url = 'http://kresq.herokuapp.com/resq/userpost/${p.postId}/';
    Response response = await delete(url, headers: {
      'Authorization': 'Token $token',
      "Content-type": "application/json"
    });
    print("from deletepost function");
    print(response.body);
  }

  getFirstPosts() {
    print("Entered _getFirstPosts()");
    return getPosts('http://kresq.herokuapp.com/resq/userpost/');
  }

  getAnnouncements() {
    print("Entered _getAnnouncements()");
    return getPosts(
        'http://kresq.herokuapp.com/resq/userpost/?isAnnouncement=True');
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
    print(statuscode);
    print(response);
    print(response.body);
    return response;
  }
}
