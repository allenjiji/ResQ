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
        keyboardType: TextInputType.text,
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
            SharedPreferences prefs = await SharedPreferences.getInstance();
            p.phone = prefs.getString("phone");
            p.name = prefs.getString("name");
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              print("${p.category}");
              _post.makePost(p);
            }
            Navigator.of(context).pop();
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
              "POST SENT....IT WILL APPEAR ON FEED PAGE SOON.",
              textAlign: TextAlign.center,
            )));
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
                  isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(h / 40))),
                    context: context,
                    builder: (_) {
                      return Container(
                        height: h*.75,
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
