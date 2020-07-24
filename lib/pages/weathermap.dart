import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherMap extends StatefulWidget {
  static const routeName = '/weathermap';
  @override
  _WeatherMapState createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Map"),
      ),
      body: WebView(
        
        initialUrl: 'https://www.windy.com/',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
    );
  }
}
