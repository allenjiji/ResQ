import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';

class Contacts extends StatelessWidget {
  Future get_list() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String url =
        "http://kresq.herokuapp.com/resq/userprofile/?lat=${position.latitude}&lon=${position.longitude}";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      if (7 < jsonResponse.length) jsonResponse = jsonResponse.subList(0, 7);
      var kj = [];
      jsonResponse.forEach((elem) => kj.add({elem['name'], elem['phone']}));
      return kj;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              'General Helpline Numbers',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('''State Emergency Operation Centre: 9446568222

State Toll-free helpline: 1070

State control room: 0471–2331639, 23333198

District toll-free helpline: 1077'''),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text('Numbers of Volunteers nearby',
                style: TextStyle(fontSize: 30)),
          ),
          FutureBuilder(builder: null),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text('Districtwise Helpline Numbers',
                style: TextStyle(fontSize: 30)),
          ),
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
          )
        ],
      ),
    );
  }
}
