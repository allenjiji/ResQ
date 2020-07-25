import 'package:flutter/material.dart';
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

class _FeedState extends State<Feed> {
  String next;
  String prev;
  _getPosts(String url) async {
    print("Entered _getpost()");
    Response response = await get(url);
    int statuscode = response.statusCode;
    //String response_body = response.body;
    //print(statuscode);
    //print(response);
    //print(response_body);
    return response;
  }

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcemment";
    if (isDonate) return "supply";
  }

  _getFirstPosts() {
    print("Entered _getFirstPosts()");
    return _getPosts('http://kresq.herokuapp.com/resq/userpost/');
  }

  _loadmore() {
    print("Entered _loadmore()");
    return _getPosts(next);
  }

  _makePost() async {}

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
                        items: <Widget>[],
                      );
                    })),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getFirstPosts(),
            builder: (context, snapshot) {
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
                        onEndOfPage: () => _loadmore(),
                        child: ListView.builder(
                          itemCount: data['results'].length,
                          itemBuilder: (context, index) {
                            return FeedBox(
                              heading: data['results'][index]["heading"],
                              genre: _genreDecider(
                                  data['results'][index]["isRequest"],
                                  data['results'][index]["isDonate"],
                                  data['results'][index]["isAnnouncement"]),
                              feedId: data['results'][index]["id"],
                              contactNo: data['results'][index]["contactphn"],
                              isVoted: data['results'][index]["upvotes"]
                                      .contains("Anandhan")
                                  ? true
                                  : false,
                              votes: data['results'][index]["upvotes"].length,
                              description: data['results'][index]["content"],
                              imgLink: data['results'][index]["image"] == null
                                  ? "https://raw.githubusercontent.com/allenjiji/ResQ/front-end/lib/08_color.png?token=ALNRNEZXEUK4AIA42FAXKMS7DKV6M"
                                  : data['results'][index]["image"],
                              name: data['results'][index]["userprofile"].toString() ,
                            );
                          },
                        ),
                      );
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
