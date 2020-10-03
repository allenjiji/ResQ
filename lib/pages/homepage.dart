import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './feedpage.dart';
import 'morepage.dart';
import 'mapspage.dart';
import 'contactspage.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "RESQ",
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 5,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            //titleSpacing: 50.0,
            //centerTitle: true,
            backgroundColor: Colors.white, elevation: 0,
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            Feed(),
            More(),
            Maps(),
            Contacts(),
          ]),
          bottomNavigationBar: Container(
            //color: Colors.grey,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.featured_play_list), text: "Feed"),
                Tab(icon: Icon(Icons.apps), text: "More"),
                Tab(
                  icon: Icon(Icons.location_on),
                  text: "Maps",
                ),
                Tab(icon: Icon(Icons.phone), text: "Contacts")
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  void getLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
