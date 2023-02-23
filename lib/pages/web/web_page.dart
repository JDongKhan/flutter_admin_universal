import '/platform/platform_adapter.dart';
import 'package:flutter/material.dart';

/// @author jd

class WebPage extends StatelessWidget {
  final String url;
  const WebPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return platformAdapter.createWebView(url);
  }
}
