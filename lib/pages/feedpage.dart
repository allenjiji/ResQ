import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  _getPosts() async {
    print("Entered");
    String url = 'http://26dd09c3920e.ngrok.io/resq/userpost/';
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
            onTap: () => _getPosts(),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getPosts(),
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
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      var data = snap.data;
                      print("object is $data");
                      final body = json.decode(data);
                      return FeedBox(
                        /* imgLink:
                            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg", */
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
                            ? "https://www.gigabyte.com/FileUpload/Global/KeyFeature/1270/img/product/08_color.png"
                            : body['results'][index]["image"],
                        name: "Anandhan",
                      );
                    },
                  );
                })

            /* ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return FeedBox(
                  heading: "Hello World !",
                  genre: "request",
                  feedId: 45,
                  isVoted: true,
                  votes: 5,
                  description:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  imgLink:
                      'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg',
                  name: "Anandhan",
                );
              },
            ) */
            ,
          ),
        ],
      ),
    );
  }
}
