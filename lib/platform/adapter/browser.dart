import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

/// @author jd

PlatformAdapter createAdapter() => BrowserAdapter();

class BrowserAdapter implements PlatformAdapter {
  BrowserAdapter() {
    js.context['flutterMethod'] = flutterMethod;
  }

  String flutterMethod() {
    return '我是flutter代码';
  }

  @override
  void log(String message) {
    // String jsString = getJSString();
    String jsString = js.context.callMethod('getJSString');
    debugPrint('我的是web端:$jsString');
  }
}
