import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resq/common_file.dart';
import 'package:resq/pages/announcements.dart';
import 'package:resq/pages/faq.dart';
import 'package:resq/pages/faqPage.dart';
import 'package:resq/pages/guidePage.dart';
import 'package:resq/pages/login_page.dart';
import './pages/homepage.dart';
import './pages/weathermap.dart';
import './pages/register_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => LoggedUser(), child: MyApp()));
}

Position location;
bool isLogin = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoggedUser user = Provider.of<LoggedUser>(context, listen: false);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
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
        WeatherMap.routeName: (context) => WeatherMap(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        FAQPage.routeName:(context)=>FAQPage(),
        GuidePage.routeName:(context)=>GuidePage(),
        Announcement.routeName: (context) => ChangeNotifierProvider(
            create: (context) => Post(), child: Announcement()),
          
      },
    );
  }
}
