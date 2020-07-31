import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:resq/common_file.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    LoggedUser user = LoggedUser();
    Future enrichUser() async {
      user.phone = await user.getSavedUserPhone();
      Response response = await user.getUserid(user);
      print(user.phone);

      return response;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: Container(
        child: Center(
            child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              print(snapshot.data);
              var body = snapshot.data.body;
              print(snapshot.data.body);
              var data = json.decode(body);
              print(data[0]["id"]);
              user.id = data[0]["id"].toString();
              user.name = data[0]["name"];
              user.isVolunteer = data[0]["is_volunteer"];
              return ListView(
                children: <Widget>[
                  ListTile(
                    leading: Text("Name:"),
                    title: Text(user.name),
                  ),
                  ListTile(
                    leading: Text("id:"),
                    title: Text(user.id),
                  ),
                  ListTile(
                    leading: Text("Phone:"),
                    title: Text(user.phone),
                  ),
                  ListTile(
                    leading: Text("Is a Volunteer:"),
                    title: Text(user.isVolunteer ? "YES" : "NO"),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator(
                backgroundColor: Colors.red,
              );
            }
          },
          future: enrichUser(),
        )),
      ),
    );
  }
}
