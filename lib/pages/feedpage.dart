import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common_file.dart';
import '../custom_widgets.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

List<List<String>> dropdownItems = [
  ["Rescue", "rescue"],
  ["Water", "water"],
  ["Food", "food"],
  ["Clothing", "clothing"],
  ["Medicine", "medicine"],
  ["Toiletries", "toiletries"],
  ["Service", "service"],
  ["Other Needs", "others"],
];
List<List<String>> dropdownItems2 = [
  ["Request", "request"],
  ["Announcement", "announcement"],
  ["Donate", "donate"],
];

class _FeedState extends State<Feed> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  void initState() {
    //print("inside initState() next==>$next");
    super.initState();
    isloading = true;
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Post p = new Post();
  String next =
      'http://kresq.herokuapp.com/resq/userpost/?ordering=-creationtime';

  List posts = [];

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcement";
    if (isDonate) return "supply";
  }

  String currentUserId;
  getCurrentUser(LoggedUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phone = prefs.getString('phone');
    //print(phone);
    user.phone = phone;
    Response response = await user.getUserid(user);
    user.id = json.decode(response.body)[0]["id"].toString();
    currentUserId = json.decode(response.body)[0]["id"].toString();
  }

  @override
  Widget build(BuildContext context) {
    final Post _post = Provider.of<Post>(context, listen: false);

    LoggedUser user = LoggedUser();

    getCurrentUser(user);
    print(currentUserId);
    print("(inside build)currentUserId is $currentUserId");
    final h = MediaQuery.of(context).size.height;
    List<Widget> bottomSheetItems = [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Place", labelText: "Place"),
        onSaved: (newValue) => p.place = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "District", labelText: "District"),
        onSaved: (newValue) => p.district = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      NewDropDown2(
        dropDownItems: dropdownItems2,
        postObject: p,
      ),
      NewDropDown(
        dropDownItems: dropdownItems,
        postObject: p,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Heading", labelText: "Heading"),
        onSaved: (newValue) => p.heading = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        decoration: InputDecoration(
            hintText: "Description", labelText: "Description"),
        onSaved: (newValue) => p.description = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () async {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            p.position = position;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            p.phone = prefs.getString("phone");
            p.name = prefs.getString("name");
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              print("${p.category}");
              _post.makePost(p);
              Navigator.of(context).pop();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                "POST SENT....IT WILL APPEAR ON FEED PAGE SOON.",
                textAlign: TextAlign.center,
              )));
            }
          },
          child: Text(
            "SUBMIT",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    ];
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            child: ListTile(
                leading: Icon(
                  Icons.add_box,
                  color: Colors.red,
                  size: h / 20,
                ),
                title: Text(
                  "Want to Post something important?",
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.red),
                onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(h / 40))),
                    context: context,
                    builder: (_) {
                      return Container(
                        height: h * .90,
                        child: BottomContainerForm(
                          formKey: formKey,
                          items: bottomSheetItems,
                        ),
                      );
                    })),
          ),
          Expanded(
              child: isloading
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
                              showremove:
                                  posts[index]["userprofile"].toString() ==
                                      currentUserId);
                        },
                      ),
                      onEndOfPage: () => fetch())),
        ],
      ),
    );
  }

  Post _post = Post();
  fetch() async {
    Response response = await _post.getPosts(next);
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
