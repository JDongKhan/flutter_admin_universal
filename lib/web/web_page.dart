import 'package:flutter/material.dart';

/// @author jd

class WebPage extends StatefulWidget {
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('我是Web页'),
        ],
      ),
    );
  }
}
