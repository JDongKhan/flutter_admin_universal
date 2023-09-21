import 'package:flutter/material.dart';

import 'adapter/web_view_io_adapter.dart' if (dart.library.html) 'adapter/web_view_browser_adapter.dart';

WebViewAdapter webViewPlatformAdapter = createAdapter();

abstract class WebViewAdapter {
  Widget createWebView(String? url, {String? htmlContentString, String? title, bool? hideAppBar, bool? hideAppBarExt});
}
