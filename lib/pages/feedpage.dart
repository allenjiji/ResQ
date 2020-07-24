import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String next;
  String prev;
  _getPosts(String url) async {
    print("Entered");
    Response response = await get(url);
    int statuscode = response.statusCode;
    String response_body = response.body;
    print(statuscode);
    print(response);
    print(response_body);

    return response_body;
  }

  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcemment";
    if (isDonate) return "supply";
  }

  _getFirstPosts() {

  }

  _loadmore() {

  }

  _makePost() async {}

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
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
            onTap: () => _makePost(),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getPosts('http://26dd09c3920e.ngrok.io/resq/userpost/'),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.none &&
                      snap.hasData == null) {
                    print(snap.data);
                    return Center(
                      child: Text("No Internet Connection"),
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return LazyLoadScrollView(
                    onEndOfPage: () => _loadmore(),
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        var data = snap.data;
                        print("object is $data");
                        final body = json.decode(data);
                        next = body['next'];
                        prev = body['previous'];
                        return FeedBox(
                          heading: body['results'][index]["heading"],
                          genre: _genreDecider(
                              body['results'][index]["isRequest"],
                              body['results'][index]["isDonate"],
                              body['results'][index]["isAnnouncement"]),
                          feedId: body['results'][index]["id"],
                          isVoted: body['results'][index]["upvotes"]
                                  .contains("Anandhan")
                              ? true
                              : false,
                          votes: body['results'][index]["upvotes"].length,
                          description: body['results'][index]["content"],
                          imgLink: body['results'][index]["image"] == null
                              ? "https://raw.githubusercontent.com/allenjiji/ResQ/front-end/lib/08_color.png?token=ALNRNEZXEUK4AIA42FAXKMS7DKV6M"
                              : body['results'][index]["image"],
                          name: "Anandhan",
                        );
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
