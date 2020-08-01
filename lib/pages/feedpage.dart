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
  ["Rescue/രക്ഷാപ്രവർത്തനം", "rescue"],
  ["Water/വെള്ളം", "water"],
  ["Food/ഭക്ഷണം", "food"],
  ["Clothing/വസ്ത്രം", "clothing"],
  ["Medicine/മരുന്നുകള്‍", "medicine"],
  ["Toiletries/ശുചീകരണ സാമഗ്രികള്‍", "toiletries"],
  ["Service/സേവനം", "service"],
  ["Other Needs/മറ്റു ആവശ്യങ്ങള്‍", "others"],
];
List<List<String>> dropdownItems2 = [
  ["Request/അഭ്യർത്ഥന", "request"],
  ["Announcement/അറിയിപ്പുകൾ", "announcement"],
  ["Donate/ദാനം", "donate"],
];

class _FeedState extends State<Feed> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Post p = new Post();
  String next =
      'http://kresq.herokuapp.com/resq/userpost/?ordering=-creationtime';
  bool hadData = true;
  bool isloading = false;
  List posts;

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcement";
    if (isDonate) return "supply";
  }

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
    final Post _post = Provider.of<Post>(context, listen: false);
    final LoggedUser user = LoggedUser();
    getCurrentUser(user);
    print(currentUserId);
    final h = MediaQuery.of(context).size.height;
    List<Widget> bottonSheetItems = [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Name/പേര് ", labelText: "Name/പേര് "),
      ),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration:
            InputDecoration(hintText: "Phone/ഫോൺ ", labelText: "Phone/ഫോൺ "),
        onSaved: (newValue) => p.phone = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Place/സ്ഥലം", labelText: "Place/സ്ഥലം"),
        onSaved: (newValue) => p.place = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "District/ജില്ല", labelText: "District/ജില്ല"),
        onSaved: (newValue) => p.district = newValue,
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
            hintText: "Heading/തലക്കെട്ട്", labelText: "Heading/തലക്കെട്ട്"),
        onSaved: (newValue) => p.heading = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "Description/വിവരണം", labelText: "Description/വിവരണം"),
        onSaved: (newValue) => p.description = newValue,
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () async {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            p.position = position;
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              print("${p.category}");
              _post.makePost(p);
            }
          },
          child: Text("SUBMIT"),
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
                  "Want to Post something important?\nപോസ്റ്റ് ചെയ്യുക",
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.red),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return BottomContainerForm(
                        formKey: formKey,
                        items: bottonSheetItems,
                      );
                    })),
          ),
          Expanded(
              child: FutureBuilder(
            future: _post.getPosts(next),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: Text("Loading..."));
                  break;
                case ConnectionState.done:
                  {
                    print("done");
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      var snapResponse = snapshot.data;
                      var snapData = snapResponse.body;
                      print(snapData);
                      var data = json.decode(snapData);
                      print(data);
                      if (data["results"].length == 0) {
                        return Center(child: Text("No Feeds"));
                      }
                      next = data["next"];
                      posts == null
                          ? posts = data["results"]
                          : posts.addAll(data["results"]);
                      //posts = data["results"];
                      return LazyLoadScrollView(
                        onEndOfPage: () {
                          if (next != null) setState(() {});
                        },
                        child: ListView.builder(
                          itemCount: (posts.length),
                          itemBuilder: (context, index) {
                            if (index >= posts.length && isloading) {
                              return Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ));
                            }
                            Post p = new Post(
                                description: posts[index]["content"],
                                heading: posts[index]["heading"],
                                genre: _genreDecider(
                                    posts[index]["isRequest"],
                                    posts[index]["isDonate"],
                                    posts[index]["isAnnouncement"]),
                                isVoted:
                                    posts[index]["upvotes"].contains("Anandhan")
                                        ? true
                                        : false,
                                phone: posts[index]["contactphn"],
                                position: Position(
                                    latitude: double.parse(posts[index]["lat"]),
                                    longitude:
                                        double.parse(posts[index]["lon"])),
                                image: posts[index]["image"] == null
                                    ? ""
                                    : posts[index]["image"],
                                postId: posts[index]["id"],
                                votes: posts[index]["upvotes"].length,
                                name: posts[index]["userprofile"].toString());
                            return FeedBox(
                              p: p,
                              
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: Text("No Internet Connection"));
                    }
                  }
                  break;
                case ConnectionState.none:
                  return Center(child: Text("None"));
                  break;
                default:
                  return Center(child: Text("Default return by switch"));
              }
            },
          )),
        ],
      ),
    );
  }
}
