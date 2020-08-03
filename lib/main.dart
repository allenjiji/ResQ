import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq/common_file.dart';
import 'package:resq/pages/myprofile.dart';
import 'package:resq/pages/announcements.dart';
import 'package:resq/pages/faqPage.dart';
import 'package:resq/pages/guidePage.dart';
import 'package:resq/pages/login_page.dart';
import 'package:resq/pages/myposts.dart';
import './pages/homepage.dart';
import './pages/weathermap.dart';
import './pages/register_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => LoggedUser(), child: MyApp()));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Position location;
bool isLogin = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoggedUser user = Provider.of<LoggedUser>(context, listen: false);
    return MaterialApp(
      title: 'RESQ',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.cantarellTextTheme(
          Theme.of(context).textTheme,
        ),
        /* textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ), */
      ),
      debugShowCheckedModeBanner: false,
      //home: MyHomePage(),
      routes: {
        '/': (context) => FutureBuilder(
              builder: (context, snapshot) {
                //print(" ${snapshot.data}");
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return ChangeNotifierProvider(
                        create: (context) => Post(), child: MyHomePage());
                  }
                  return RegisterPage();
                }
                return Container();
              },
              future: user.isLoggedin(),
            ),
        WebPage.routeName: (context) => WebPage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        FAQPage.routeName: (context) => FAQPage(),
        GuidePage.routeName: (context) => GuidePage(),
        MyPosts.routeName: (context) => MyPosts(),
        Profile.routeName: (context) => Profile(),
        Announcement.routeName: (context) => ChangeNotifierProvider(
            create: (context) => Post(), child: Announcement()),
      },
    );
  }
}
