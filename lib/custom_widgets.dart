import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_file.dart';

class FeedBox extends StatefulWidget {
  FeedBox(
      {Key key,
      @required this.votes,
      @required this.genre,
      @required this.contactNo,
      @required this.name,
      @required this.isVoted,
      @required this.description,
      @required this.heading,
      this.imgLink,
      @required this.feedId})
      : super(key: key);

  final String name;
  int votes;
  final String heading;
  final String genre;
  final int feedId;
  var isVoted;
  final contactNo;
  final String imgLink;
  final String description;

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
  @override
  Widget build(BuildContext context) {
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
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  PopupMenuButton(
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Report"),
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
              image: NetworkImage(widget.imgLink),
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
                  color: widget.colorDecider(widget.genre),
                )),
              ),
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Text(widget.heading),
                  Text(
                    widget.description,
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
                    color: !widget.isVoted
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                  ),
                  onTap: () {
                    if (widget.isVoted) {
                      setState(() {
                        widget.votes -= 1;
                        widget.isVoted = false;
                      });
                    } else {
                      setState(() {
                        widget.votes += 1;
                        widget.isVoted = true;
                      });
                    }
                  },
                ),
                Text("${widget.votes} Upvotes"),
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
                                  ),
                                  InkWell(
                                    child: ListTile(
                                      title: Text(
                                        "Phone",
                                      ),
                                    ),
                                    onTap: () => () async {
                                      String url = "tel:" + widget.contactNo;
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
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
  final Post postObject ;
  NewDropDown({@required this.dropDownItems,@required this.postObject});
  @override
  _NewDropDownState createState() => _NewDropDownState();
}

class _NewDropDownState extends State<NewDropDown> {
  String _selectedValue = null;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text("Select Your Need"),
      value: _selectedValue,
      items: widget.dropDownItems
          .map((e) => DropdownMenuItem(
                child: Text(e[0]),
                value: e[1],
              ))
          .toList(),
      onChanged: (value) {
        print("selected $value from dropdown");
        widget.postObject.genre=value;
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
