import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:resq/common_file.dart';
import 'dart:convert';
import '../custom_widgets.dart';

class MyPosts extends StatelessWidget {
  String _genreDecider(bool isRequest, bool isDonate, bool isAnnouncement) {
    if (isRequest) return "request";
    if (isAnnouncement) return "announcement";
    if (isDonate) return "supply";
  }

  static const routeName = '/myposts';
  Post postObject = Post();
  String next;
  @override
  Widget build(BuildContext context) {
    LoggedUser user = LoggedUser();
    Post post = Post();
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: Center(
        child: FutureBuilder(
          future: post.getMyPosts(),
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
                    next = data["next"];

                    return LazyLoadScrollView(
                      onEndOfPage: () => postObject.loadmore(next),
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
                            //category: "announcement",
                            isVoted: data['results'][index]["upvotes"]
                                    .contains("Anandhan")
                                ? true
                                : false,
                            phone: data['results'][index]["contactphn"],
                            image: data['results'][index]["image"] == null
                                ? ''
                                : data['results'][index]["image"],
                            postId: data['results'][index]["id"],
                            votes: data['results'][index]["upvotes"].length,
                            name: data['results'][index]["userprofile"]
                                .toString(),
                          );
                          return FeedBox(
                            p: p,
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
                return Center(child: Text("Default return by switch"));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
