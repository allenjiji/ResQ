import 'package:flutter/material.dart';
import './faq.dart';

class FAQPage extends StatelessWidget {
  static const routeName = '/faqpage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQ'),
        ),
        body: ListView.builder(
            itemCount: Faq.qn.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                child: ExpansionTile(
                  title: Text(Faq.qn[index],
                      style: TextStyle(fontSize: 21, color: Colors.black)),
                  children: <Widget>[Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                    child: Text(Faq.ans[index],style: TextStyle(fontSize: 17),),
                  )],
                ),
              );
            }));
  }
}
