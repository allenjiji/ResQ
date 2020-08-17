import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:resq/common_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../custom_widgets.dart';

class Announcement extends StatefulWidget {
  static const routeName = '/announcement';
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    isloading = true;
    fetch();
  }

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcement";
    if (isDonate) return "supply";
  }

  String next;

  List posts = [];

  String currentUserId;

  getCurrentUser(LoggedUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phone = prefs.getString('phone');
    print(phone);
    user.phone = phone;
    Response response = await user.getUserid(user);
    user.id = json.decode(response.body)[0]["id"].toString();
    currentUserId = json.decode(response.body)[0]["id"].toString();
  }

  @override
  Widget build(BuildContext context) {
    LoggedUser user = LoggedUser();

    getCurrentUser(user);
    print(currentUserId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
      ),
      body: isloading
          ? Center(
              child: Text("Loading..."),
            )
          : LazyLoadScrollView(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  //return Text("${posts[index]["userprofile"]} and $index");
                  Post p = new Post(
                      description: posts[index]["content"],
                      heading: posts[index]["heading"],
                      genre: _genreDecider(
                          posts[index]["isRequest"],
                          posts[index]["isDonate"],
                          posts[index]["isAnnouncement"]),
                      isVoted: posts[index]["upvotes"]
                          .contains(int.parse(currentUserId)),
                      //isVoted: false,
                      phone: posts[index]["contactphn"],
                      position: Position(
                          latitude: double.parse(posts[index]["lat"]),
                          longitude: double.parse(posts[index]["lon"])),
                      image: posts[index]["image"] == null
                          ? ""
                          : posts[index]["image"],
                      postId: posts[index]["id"],
                      votes: posts[index]["upvotes"].length,
                      name: posts[index]["userprofile"].toString());
                  return FeedBox(
                      p: p,
                      showremove: posts[index]["userprofile"].toString() ==
                          currentUserId);
                },
              ),
              onEndOfPage: () => fetch()),
    );
  }

  Post _post = Post();

  fetch() async {
    Response response = await _post.getAnnouncements();
    if (response.statusCode == 200) {
      next = json.decode(response.body)["next"];
      //print("this is new line:===>>${json.decode(response.body)["results"]}");
      setState(() {
        posts.addAll(json.decode(response.body)["results"]);
        isloading = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }
}
