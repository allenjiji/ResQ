import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneConroller = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final phoneField = TextField(
      keyboardType: TextInputType.number,
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
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print(phoneConroller.text);
          print(passController.text);
        },
        child: Text("LOGIN",
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
                passwordField,
                SizedBox(
                  height: h / 20,
                ),
                loginButon,
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
