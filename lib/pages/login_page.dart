import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:resq/common_file.dart';
import 'package:resq/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;
  bool showerror1 = false;
  bool showerror2 = false;
  bool error = false;
  @override
  dispose() {
    super.dispose();
    widget.phoneController.dispose();
    widget.passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggedUser user = LoggedUser();
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final phoneField = TextField(
      keyboardType: TextInputType.number,
      //style: style,
      controller: widget.phoneController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          errorText: showerror1 ? "Enter a valid Phone Number" : null,
          hintText: "Phone",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: widget.passController,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          errorText: showerror2 ? "Enter a valid Password" : null,
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
        onPressed: () async {
          print(widget.phoneController.text);
          print(widget.passController.text);
          if (widget.phoneController.text.length != 10) {
            setState(() {
              showerror1 = true;
            });
          }
          if (widget.passController.text.length < 8) {
            setState(() {
              showerror2 = true;
            });
          }
          if (widget.phoneController.text.length == 10 &&
              widget.passController.text.length >= 8) {
            setState(() {
              error=false;
              isloading = true;
            });
            var res = await user.login(context, widget.phoneController.text,
                widget.passController.text);
            print(" for now midnignt ====-->>$res");
            if (res != 200) {
              setState(() {
                isloading = false;
                error = true;
              });
            }
          }
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
                  passwordField,
                  SizedBox(
                    height: h / 20,
                  ),
                  loginButon,
                  SizedBox(
                    height: h / 50,
                  ),
                  InkWell(
                    child: Center(
                      child: Text(
                        "New User ? Register",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(RegisterPage.routeName),
                  ),
                  Container(
                      child: isloading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            )
                          : Container()),
                  Container(
                      child: error
                          ? Text(
                              "INVALID LOGIN",
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
