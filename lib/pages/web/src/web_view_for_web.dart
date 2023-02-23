import 'dart:ui' as ui;
import 'dart:html';

import 'package:flutter/material.dart';

class WebViewForWeb extends StatelessWidget {
  final String url;
  const WebViewForWeb({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IFrameElement iframeElement = IFrameElement();
    iframeElement.src = url;
    iframeElement.style.border = 'none';
// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => iframeElement,
    );
    return HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }
}
