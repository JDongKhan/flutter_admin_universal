import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/home/widget/main_top_widget.dart';

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
          MainTopWidget(),
          Expanded(
            child: Center(
              child: Text('我是Web页'),
            ),
          ),
        ],
      ),
    );
  }
}
