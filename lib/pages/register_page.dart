import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:resq/main.dart';
import 'package:resq/pages/login_page.dart';

import '../common_file.dart';

class RegisterPage extends StatefulWidget {
  final Position location = null;
  static const routeName = '/register';
  final phoneConroller = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isloading = false;
  bool showerror1 = false;
  bool showerror2 = false;
  bool showerror3 = false;
  bool exists = false;
  @override
  dispose() {
    super.dispose();
    widget.phoneConroller.dispose();
    widget.nameController.dispose();
    widget.passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoggedUser user = Provider.of<LoggedUser>(context, listen: false);

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final phoneField = TextField(
      keyboardType: TextInputType.number,
      //style: style,
      controller: widget.phoneConroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone/ഫോൺ",
          errorText: showerror1 ? "Enter a valid Phone Number" : null,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: widget.passController,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password/പാസ്സ്‌വേർഡ്",
          errorText: showerror3 ? "Enter minimum 8 characters" : null,
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
        onPressed: () async {
          print("hello ${widget.phoneConroller.text}");
          print(widget.passController.text);
          print(widget.nameController.text);
          if (widget.phoneConroller.text.length != 10) {
            setState(() {
              showerror1 = true;
            });
          } else {
            setState(() {
              showerror1 = false;
            });
          }
          if (widget.nameController.text.isEmpty) {
            setState(() {
              showerror2 = true;
            });
          } else {
            setState(() {
              showerror2 = false;
            });
          }
          if (widget.passController.text.length < 8) {
            setState(() {
              showerror3 = true;
            });
          } else {
            setState(() {
              showerror3 = false;
            });
          }
          if (widget.nameController.text.isNotEmpty &&
              widget.passController.text.length >= 8 &&
              widget.phoneConroller.text.length == 10) {
            setState(() {
              isloading = true;
            });

            user.name = widget.nameController.text;
            user.phone = widget.phoneConroller.text;
            user.password = widget.passController.text;
            var location = await user.getLocation();
            Response response = await user.register(
                (widget.phoneConroller.text),
                (widget.passController.text),
                (widget.nameController.text),
                context,
                location);
            print(
                "object====>===>==>====>${json.decode(response.body)["phone"]}");
            if (json.decode(response.body)["phone"] !=
                widget.phoneConroller.text) {
              setState(() {
                exists = true;
                isloading = false;
              });
            } else {
              user.login(context, widget.phoneConroller.text,
                  widget.passController.text);
            }
          }
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: h / 5,
                    child: Image.asset(
                      "lib/assets/playstore.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: h / 10),
                  phoneField,
                  SizedBox(height: h / 50),
                  TextField(
                    keyboardType: TextInputType.text,
                    //style: style,
                    controller: widget.nameController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Name/പേര്",
                        errorText: showerror2 ? "Enter a valid Name" : null,
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
                  InkWell(
                    child: Center(
                      child: exists
                          ? Text("This Phone is already registered.Try LOGIN",
                              style: TextStyle(color: Colors.red))
                          : Text("Alredy a user? Login",
                              style: TextStyle(color: Colors.red)),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(LoginPage.routeName),
                  ),
                  Container(
                      child: isloading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            )
                          : Container())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
