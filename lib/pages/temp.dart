import 'package:flutter/material.dart';

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
                          /*  if (next != null) setState(() {}); */
                        },
                        child: ListView.builder(
                          itemCount: (posts.length),
                          itemBuilder: (context, index) {
                            if (index >= posts.length && isloading) {
                              return Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ));
                            }
                            /* print(posts[index]["upvotes"]
                                .contains(int.parse(currentUserId))); */
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
                                showremove: posts[index]["userprofile"] ==
                                    int.parse(currentUserId));
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
          )