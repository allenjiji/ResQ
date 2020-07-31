import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future get_list() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String url =
        "http://kresq.herokuapp.com/resq/userprofile/?lat=${position.latitude}&lon=${position.longitude}&is_volunteer=False";
    var response = await http.get(url);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        //padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ExpansionTile(
              title: Text(
                'Districtwise Helpline Numbers',
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('''Kasaragod: 9446601700, 0499-4257700

Kannur: 9446682300, 0497-2713266

Wayanad: 9446394126, 8078409770

Kozhikode: 9446538900, 0495-2371002

Malappuram: 9383463212, 0483-2736320

Palakkad: 8301803282, 0491-2505309

Thrissur: 9447074424, 0487-2362424

Ernakulam (Kochi): 7902200400, 0484-2423513

Idukki: 9383463036, 0486-2233111

Kottayam: 9446562236, 0481-2304800

Alappuzha: 9495003640, 0477-2238630

Pathanamthitta: 8078808915, 0468-2322515

Kollam: 9447677800, 0474-2794002

Thiruvananthapuram: 9497711281, 0471-2730045'''),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'General Helpline Numbers',
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('''State Emergency Operation Centre: 9446568222

State Toll-free helpline: 1070

State control room: 0471–2331639, 23333198

District toll-free helpline: 1077'''),
                ),
              ],
            ),
            ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Nearby Volteers within 60 kms',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              children: <Widget>[
                FutureBuilder(
                  future: get_list(),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    print(snapshot.hasData);
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      //var data = json.decode(snapshot.data);
                      var content = json.decode(snapshot.data.body);
                      print(json.decode(snapshot.data.body));
                      return Container(
                        height: MediaQuery.of(context).size.height * .41,
                        child: ListView.builder(
                          itemCount: content.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(content[index]["name"]),
                              trailing: InkWell(
                                child: Text(
                                  content[index]["phone"],
                                  style: TextStyle(
                                      color: Colors.red,
                                      backgroundColor: Colors.yellow),
                                ),
                                onTap: () =>
                                    launchCaller(content[index]["phone"]),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ));
  }
}
