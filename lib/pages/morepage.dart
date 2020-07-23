import 'package:flutter/material.dart';
import 'dart:math' as math;

class More extends StatelessWidget {
  List<Color> colors = [Colors.blue];
  List<List<Object>> texts = [
    ["Request Rescue", "രക്ഷാപ്രവർത്തന\nഅഭ്യർത്ഥന", Icons.add_alert],
    ["Weather Map", "കാലാവസ്ഥ ഭൂപടം ", Icons.map],
    ["Announcements", "അറിയിപ്പുകൾ", Icons.speaker],
    ["Donate", "സംഭാവന", Icons.control_point_duplicate],
    ["Volunteer\nRegistration", "രക്ഷാപ്രവർത്തകർ റെജി.", Icons.person_outline],
    ["FAQ", "ചോദ്യങ്ങൾ", Icons.help_outline],
    ["Guide", "നിർദ്ദേശങ്ങൾ", Icons.message],
    ["My Profile", "പ്രൊഫൈൽ", Icons.portrait],
    ["Medical Support", "വൈദ്യ സഹായം", Icons.local_hospital],
    ["My Posts", "പോസ്റ്റുകൾ", Icons.photo_size_select_large],
  ];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Container(
      //color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      color: Colors.grey[400],
      child: GridView.count(
        crossAxisCount: 2,
        //padding: EdgeInsets.all(h / 30),
        children: List.generate(10, (index) {
          return Container(
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
          );
        }),
      ),
    );
  }
}
