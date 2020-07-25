import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/common_file.dart';
import 'package:flutter/material.dart';
import 'package:resq/bottom_sheet.dart';
import 'package:resq/custom_widgets.dart';
import 'package:resq/pages/announcements.dart';
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
  List<Color> colors = [Colors.blue];

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
    ["Medical Support", "വൈദ്യ സഹായം", Icons.local_hospital],
    ["My Posts", "പോസ്റ്റുകൾ", Icons.photo_size_select_large],
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
    Post p = new Post();
    final GlobalKey<FormState> formKey = GlobalKey();

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
    var h = MediaQuery.of(context).size.height;
    return Container(
      //color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      color: Colors.grey[400],
      child: GridView.count(
        crossAxisCount: 2,
        //padding: EdgeInsets.all(h / 30),
        children: List.generate(10, (index) {
          return InkWell(
            onTap: () {
              print("tapped the $index th block");

              switch (index) {
                case 0:
                  showModalBottomSheet(
                      enableDrag: true,
                      //isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(h / 40))),
                      context: context,
                      builder: (_) {
                        return BottomContainerForm(
                          formKey: formKey,
                          items: bottonSheetItems,
                        );
                      });

                  break;
                case 1:
                  Navigator.of(context).pushNamed(WeatherMap.routeName);
                  break;
                case 2:
                  Navigator.of(context).pushNamed(Announcement.routeName);
                  break;
                default:
              }
            },
            child: Container(
              margin: EdgeInsets.all(h / 60),
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
                      size: h / 15,
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
