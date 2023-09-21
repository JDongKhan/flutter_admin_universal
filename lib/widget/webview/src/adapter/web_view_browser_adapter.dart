import 'package:flutter/material.dart';

import '../web_view_adapter.dart';
import '../widget/web_view_for_web.dart';

/// @author jd

WebViewAdapter createAdapter() => BrowserAdapter();

class BrowserAdapter implements WebViewAdapter {
  @override
  Widget createWebView(String? url, {String? htmlContentString, String? title, bool? hideAppBar, bool? hideAppBarExt}) {
    return WebViewForWeb(
      url: url,
      htmlContentString: htmlContentString,
      title: title,
      hideAppBar: hideAppBar,
    );
  }
}
