import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewForPlatform extends StatefulWidget {
  final String url;
  const WebViewForPlatform({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewForPlatform> createState() => _WebViewForPlatformState();
}

class _WebViewForPlatformState extends State<WebViewForPlatform> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
    );
  }
}
