import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/bottom_sheet.dart';
import '../common_file.dart';
import '../custom_widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
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
  ["Donate/ദാനം", "supply"],
];

class _FeedState extends State<Feed> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Post p = new Post();

  String next;
  String prev;
  

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcemment";
    if (isDonate) return "supply";
  }



  @override
  Widget build(BuildContext context) {
    final Post _post = Provider.of<Post>(context, listen: false);
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
              print("${p.genre}");
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
            future: _post.getFirstPosts(),
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
                      return LazyLoadScrollView(
                        onEndOfPage: () => _post.loadmore(next),
                        child: ListView.builder(
                          itemCount: data['results'].length,
                          itemBuilder: (context, index) {
                            Post p = new Post(
                              description: data['results'][index]["content"],
                              heading: data['results'][index]["heading"],
                              genre: _genreDecider(
                                  data['results'][index]["isRequest"],
                                  data['results'][index]["isDonate"],
                                  data['results'][index]["isAnnouncement"]),
                              isVoted: data['results'][index]["upvotes"]
                                      .contains("Anandhan")
                                  ? true
                                  : false,
                              phone: data['results'][index]["contactphn"],
                              image: data['results'][index]["image"] == null
                                  ? "https://raw.githubusercontent.com/allenjiji/ResQ/front-end/lib/08_color.png?token=ALNRNEZXEUK4AIA42FAXKMS7DKV6M"
                                  : data['results'][index]["image"],
                              postId: data['results'][index]["id"],
                              votes: data['results'][index]["upvotes"].length,
                              name: data['results'][index]["userprofile"]
                                  .toString()
                                  .toString(),
                            );
                            return FeedBox(
                              p: p,
                            );
                          },
                        ),
                      );
                    }
                    else{
                       return Center(child: Text("No Internet Connection"));
                    }
                  }
                  break;
                case ConnectionState.none:
                  return Center(child: Text("None"));
                  break;
                default:
                  return Center(child: Text("Default retirn by switch"));
              }
              return Container();
            },
          )),
        ],
      ),
    );
  }
}
