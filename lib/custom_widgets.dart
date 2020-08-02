import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_file.dart';

class FeedBox extends StatefulWidget {
  FeedBox({Key key, @required this.p, @required this.showremove})
      : super(key: key);

  final Post p;
  final bool showremove;

  Color colorDecider(String genre) {
    switch (genre) {
      case "request":
        {
          return Colors.red;
        }
        break;
      case "announcement":
        {
          return Colors.black;
        }
        break;
      case "supply":
        {
          return Colors.green;
        }
        break;
      default:
        return Colors.white;
    }
  }

  @override
  _FeedBoxState createState() => _FeedBoxState();
}

class _FeedBoxState extends State<FeedBox> {
  String currentUser;
  getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phone = prefs.getString('phone');
    String url = 'http://kresq.herokuapp.com/resq/userprofile/?phone=$phone';
    Response response = await get(url);
    //print(json.decode(response.body));
    var body = json.decode(response.body);
    currentUser = body[0]["id"].toString();
    //print(currentUser);
  }

  Post _post = Post();
  getdetails(phone) async {
    String url = 'http://kresq.herokuapp.com/resq/userprofile/?phone=$phone';
    Response response = await get(url);
    //print(response.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Container(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FutureBuilder(
                      future: getdetails(widget.p.phone),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = json.decode(snapshot.data.body)[0];
                          //var body = json.decode(data)[0]["name"];
                          return Text(
                            data["name"],
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }
                        return Text("");
                      }),
                  PopupMenuButton(
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Report"),
                            ),
                            PopupMenuItem(
                              enabled: widget.showremove,
                              child: InkWell(
                                  onTap: () {
                                    print(widget.p.postId.toString());
                                    widget.p.deletepost(widget.p);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                      "The Post will be removed Soon",
                                      textAlign: TextAlign.center,
                                    )));
                                  },
                                  child: Text("Remove")),
                            ),
                          ])
                  /* InkWell(
                      child: Icon(
                    Icons.more_vert,
                  ),
                  onTap: ,) */
                ],
              ),
            ),
          ),
          Container(
            child: Image(
              image: NetworkImage(widget.p.image),
              fit: BoxFit.cover,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                  width: MediaQuery.of(context).size.height * 0.01,
                  color: widget.colorDecider(widget.p.genre),
                )),
              ),
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.p.heading,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.p.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    Icons.arrow_upward,
                    color: !widget.p.isVoted
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                  ),
                  onTap: () {
                    if (widget.p.isVoted) {
                      widget.p.unlikepost(widget.p);
                      setState(() {
                        widget.p.votes -= 1;
                        widget.p.isVoted = false;
                      });
                    } else {
                      widget.p.likepost(widget.p);
                      setState(() {
                        widget.p.votes += 1;
                        widget.p.isVoted = true;
                      });
                    }
                  },
                ),
                Text("${widget.p.votes} Upvotes"),
                InkWell(
                    child: Text(
                      "CONTACT",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ListView(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Location"),
                                    onTap: () async {
                                      String url =
                                          'https://www.google.com/maps/search/?api=1&query=${widget.p.position.latitude},${widget.p.position.longitude}';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else
                                        throw 'Couldnot Open Googlemap';
                                    },
                                  ),
                                  InkWell(
                                    child: ListTile(
                                        title: Text(
                                          "Phone",
                                        ),
                                        onTap: () async {
                                          print(widget.p.phone);
                                          String url = "tel:${widget.p.phone}";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NewDropDown extends StatefulWidget {
  final List dropDownItems;
  final Post postObject;
  NewDropDown({@required this.dropDownItems, @required this.postObject});
  @override
  _NewDropDownState createState() => _NewDropDownState();
}

class _NewDropDownState extends State<NewDropDown> {
  String _selectedValue = null;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text("Select Item/വസ്തു"),
      value: _selectedValue,
      items: widget.dropDownItems
          .map((e) => DropdownMenuItem(
                child: Text(e[0]),
                value: e[1],
              ))
          .toList(),
      onChanged: (value) {
        print("selected $value from dropdown");
        widget.postObject.genre = value;
        widget.postObject.category = 'request';
        setState(() {
          _selectedValue = "$value";
        });
      },
      onTap: () {
        setState(() {});
      },
    );
  }
}

class NewDropDown2 extends StatefulWidget {
  final List dropDownItems;
  final Post postObject;
  NewDropDown2({@required this.dropDownItems, @required this.postObject});
  @override
  _NewDropDown2State createState() => _NewDropDown2State();
}

class _NewDropDown2State extends State<NewDropDown2> {
  @override
  String _selectedValue = null;
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text("Select Category/വിഭാഗം"),
      value: _selectedValue,
      items: widget.dropDownItems
          .map((e) => DropdownMenuItem(
                child: Text(e[0]),
                value: e[1],
              ))
          .toList(),
      onChanged: (value) {
        print("selected $value from dropdown");
        widget.postObject.category = value;
        setState(() {
          _selectedValue = "$value";
        });
      },
    );
  }
}
