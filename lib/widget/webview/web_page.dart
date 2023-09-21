import 'package:flutter/material.dart';

import 'src/web_view_adapter.dart';

/// @author jd

///web page
class WebPage extends StatelessWidget {
  const WebPage({
    super.key,
    this.url,
    this.htmlContentString,
    this.title,
    this.hideAppBar,
    this.hideAppBarExt,
  }) : assert(url != null || htmlContentString != null);
  final String? title;
  final String? url;
  final String? htmlContentString;
  final bool? hideAppBar;
  //true 默认设置高度为1
  final bool? hideAppBarExt;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: webViewPlatformAdapter.createWebView(
        url,
        htmlContentString:htmlContentString,
        title: title,
        hideAppBar: hideAppBar,
        hideAppBarExt: hideAppBarExt,
      ),
    );
  }
}
