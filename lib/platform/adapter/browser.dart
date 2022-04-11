import 'dart:html' as html;
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
    js.context.callMethod('log', [message]);
  }

  @override
  void login(String url) {
    String currentUrl = html.window.location.href + '/';
    currentUrl = Uri.encodeComponent(currentUrl);
    String loginUrl = '$url?service=$currentUrl';
    html.window.location.replace(loginUrl);
  }

  @override
  String? cookies() {
    return html.window.document.cookie;
  }

  @override
  void alert(String message) {
    js.context.callMethod('alert', [message]);
  }

  @override
  void selectFileAndUpload() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false; // 是否允许选择多文件
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      debugPrint('选择文件:$files');
      if (files != null && files.isNotEmpty) {
        html.File? file = files.single;
        final html.FormData formData = html.FormData()
          ..appendBlob('file', file.slice(), file.name);
        var url = 'http://localhost:8088/api/file/upload';
        html.HttpRequest.request(
          url,
          method: 'POST',
          sendData: formData,
        ).then((httpRequest) {
          debugPrint('上传成功');
        }).catchError((e) {});
      }
      // var fileItem = UploadFileItem(files[0]);
    });
  }

  @override
  void downloadFile(String url) {
    debugPrint('下载$url');
    html.AnchorElement downloadElemment = html.AnchorElement(href: url);
    downloadElemment.download = url;
    downloadElemment.click();
    downloadElemment.onClick.listen((event) {});
  }

  @override
  String userAgent() {
    return html.window.navigator.userAgent;
  }
}
