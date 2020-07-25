import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

import '../common_file.dart';
import '../custom_widgets.dart';

class Announcement extends StatelessWidget {
  static const routeName = '/announcemnt';
  @override
  Widget build(BuildContext context) {
    Post postObject = Provider.of<Post>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: postObject.getAnnouncements(),
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
                    onEndOfPage: () => postObject.loadmore('sds'),
                    child: ListView.builder(
                      itemCount: data['results'].length,
                      itemBuilder: (context, index) {
                        Post p = new Post(
                          description: data['results'][index]["content"],
                          heading: data['results'][index]["heading"],
                          genre: "announcement",
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
    );
  }
}
