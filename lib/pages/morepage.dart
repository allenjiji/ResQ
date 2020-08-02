import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/common_file.dart';
import 'package:flutter/material.dart';
import 'package:resq/bottom_sheet.dart';
import 'package:resq/custom_widgets.dart';
import 'package:resq/myprofile.dart';
import 'package:resq/pages/announcements.dart';
import 'package:resq/pages/faqPage.dart';
import 'package:resq/pages/guidePage.dart';
import 'package:resq/pages/myposts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import './weathermap.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

/* class RequestData {
  String district;
  String place;
  Position location;
  String name;
  String phone;
  String request;
}
 */
class _MoreState extends State<More> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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

  List<List<Object>> texts = [
    ["Requests", "അഭ്യർത്ഥനകൾ", Icons.add_alert],
    ["Weather Map", "കാലാവസ്ഥ ഭൂപടം ", Icons.map],
    ["Announcements", "അറിയിപ്പുകൾ", Icons.speaker],
    ["Donate", "സംഭാവന", Icons.control_point_duplicate],
    ["Be a Volunteer", "രക്ഷാപ്രവർത്തകനാകുക ", Icons.person_outline],
    ["FAQ", "ചോദ്യങ്ങൾ", Icons.help_outline],
    ["Guide", "നിർദ്ദേശങ്ങൾ", Icons.message],
    ["My Profile", "പ്രൊഫൈൽ", Icons.portrait],
    ["My Posts", "പോസ്റ്റുകൾ", Icons.photo_size_select_large],
    ["LOGOUT", 'ലോഗൗട്ട്', Icons.exit_to_app]
  ];
  List<String> textFieldTexts = [
    "Name/പേര് ",
    "Phone/ഫോൺ",
    "Place/സ്ഥലം",
    "District/ജില്ല"
  ];

  @override
  Widget build(BuildContext context) {
    final Post _post = Provider.of<Post>(context, listen: false);
    final LoggedUser user = LoggedUser();
    Post p = new Post();
    final GlobalKey<FormState> formKey = GlobalKey();

    List<Widget> bottonSheetItemsRequests = [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Place/സ്ഥലം", labelText: "Place/സ്ഥലം"),
        onSaved: (newValue) => p.place = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "District/ജില്ല", labelText: "District/ജില്ല"),
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
        onSaved: (newValue) => p.district = newValue,
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
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        decoration: InputDecoration(
            hintText: "Description/വിവരണം", labelText: "Description/വിവരണം"),
        onSaved: (newValue) => p.description = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () async {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            p.position = position;
            p.category = "request";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            p.phone = prefs.getString("phone");
            p.name = prefs.getString("name");
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              print("${p.genre}");
              _post.makePost(p);
              Navigator.of(context).pop();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                "POST SENT....IT WILL APPEAR ON FEED PAGE SOON.",
                textAlign: TextAlign.center,
              )));
            }
          },
          child: Text(
            "SUBMIT",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    ];
    List<Widget> bottonSheetItemsDonate = [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Place/സ്ഥലം", labelText: "Place/സ്ഥലം"),
        onSaved: (newValue) => p.place = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "District/ജില്ല", labelText: "District/ജില്ല"),
        onSaved: (newValue) => p.district = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
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
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        decoration: InputDecoration(
            hintText: "Description/വിവരണം", labelText: "Description/വിവരണം"),
        onSaved: (newValue) => p.description = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () async {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            p.position = position;
            p.category = "donate";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            p.phone = prefs.getString("phone");
            p.name = prefs.getString("name");
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              print("${p.genre}");
              _post.makePost(p);
              Navigator.of(context).pop();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                "POST SENT....IT WILL APPEAR ON FEED PAGE SOON.",
                textAlign: TextAlign.center,
              )));
            }
          },
          child: Text(
            "Donate to Public",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed(WebPage.routeName, arguments: {
              "title": "Donate to CM",
              "url": "https://donation.cmdrf.kerala.gov.in/#donation"
            });
          },
          child: Text("I want to donate to CM's Fund"),
        ),
      ),
    ];
    List<Widget> bottonSheetItemsVolunteer = [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: "Place/സ്ഥലം", labelText: "Place/സ്ഥലം"),
        onSaved: (newValue) => user.place = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "District/ജില്ല", labelText: "District/ജില്ല"),
        onSaved: (newValue) => user.district = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "House name ,Street ...", labelText: "Address/വിലാസം"),
        onSaved: (newValue) => user.address = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Medical/Survey etc...",
            labelText: "Area of Volunteering/മേഖല"),
        onSaved: (newValue) => user.areaOfVolunteer = newValue,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field Cannot be Empty';
          }
          return null;
        },
      ),
      ButtonTheme(
        minWidth: double.infinity,
        //height:,
        child: FlatButton(
          onPressed: () async {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            user.location = position;

            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print("Saved");
              //print("${p.genre}");
              user.makeVolunteer(user);
              Navigator.of(context).pop();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                "You will appear as a Volunteer to others from now.",
                textAlign: TextAlign.center,
              )));
            }
          },
          child: Text(
            "SUBMIT",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    ];
    var h = MediaQuery.of(context).size.height;
    return Container(
      //color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        //padding: EdgeInsets.all(h / 30),
        children: List.generate(texts.length, (index) {
          return InkWell(
            onTap: () {
              print("tapped the $index th block");

              switch (index) {
                case 0:
                  showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(h / 40))),
                      context: context,
                      builder: (_) {
                        return Container(
                          height: h * .75,
                          child: BottomContainerForm(
                            formKey: formKey,
                            items: bottonSheetItemsRequests,
                          ),
                        );
                      });

                  break;
                case 1:
                  Navigator.of(context).pushNamed(WebPage.routeName,
                      arguments: {
                        'title': "Weather Map",
                        "url": "https://www.windy.com/"
                      });
                  break;
                case 2:
                  Navigator.of(context).pushNamed(Announcement.routeName);
                  break;
                case 3:
                  showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(h / 40))),
                      context: context,
                      builder: (_) {
                        return Container(
                          height: h * .75,
                          child: BottomContainerForm(
                            formKey: formKey,
                            items: bottonSheetItemsDonate,
                          ),
                        );
                      });
                  break;
                case 4:
                  showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(h / 40))),
                      context: context,
                      builder: (_) {
                        return Container(
                          height: h * .75,
                          child: BottomContainerForm(
                            formKey: formKey,
                            items: bottonSheetItemsVolunteer,
                          ),
                        );
                      });
                  break;
                case 5:
                  Navigator.of(context).pushNamed(FAQPage.routeName);
                  break;
                case 6:
                  Navigator.of(context).pushNamed(GuidePage.routeName);
                  break;
                case 7:
                  Navigator.of(context).pushNamed(Profile.routeName);
                  break;
                case 8:
                  Navigator.of(context).pushNamed(MyPosts.routeName);

                  break;
                case 9:
                  user.logout(context);
                  break;
                default:
              }
            },
            child: Container(
              margin: EdgeInsets.all(h / 80),
              decoration: BoxDecoration(
                //color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                color: Colors.white,
                border: Border.all(color: Colors.black, width: h / 500),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      texts[index][2],
                      size: h / 20,
                      color: Colors.red,
                    ),
                    //Text('\n'),
                    Text(
                      texts[index][0],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      texts[index][1],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
