import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/main.dart';

import '../common_file.dart';

class RegisterPage extends StatefulWidget {
  final Position location=null;
  static const routeName = '/register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    
    final phoneConroller = TextEditingController();
    final passController = TextEditingController();
    final nameController = TextEditingController();

    final LoggedUser user = Provider.of<LoggedUser>(context,listen: false);

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final phoneField = TextField(
      keyboardType: TextInputType.text,
      //style: style,
      controller: phoneConroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone/ഫോൺ",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: passController,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password/പാസ്സ്‌വേർഡ്",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final registerButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print(phoneConroller.text);
          print(passController.text);
          print(nameController.text);
          user.name = nameController.text;
          user.phone = phoneConroller.text;
          user.password = passController.text;
          user.getLocation();
          user.register( (phoneConroller.text), (passController.text), (nameController.text));
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /* SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ), */
                SizedBox(height: h / 10),
                phoneField,
                SizedBox(height: h / 50),
                TextField(
                  keyboardType: TextInputType.text,
                  //style: style,
                  controller: nameController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Name/പേര്",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
                SizedBox(height: h / 50),
                passwordField,
                SizedBox(
                  height: h / 20,
                ),
                registerButon,
                SizedBox(
                  height: h / 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
