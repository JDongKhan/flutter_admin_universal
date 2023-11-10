import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import '../../service/environment.dart';
import '../platform_adapter.dart';

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
    String currentUrl = '${html.window.location.href}/';
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
  Future<String?> selectFileAndUpload() {
    Completer<String> completer = Completer<String>();
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false; // 是否允许选择多文件
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      _upload1(uploadInput, e, completer);
      // var fileItem = UploadFileItem(files[0]);
    });
    return completer.future;
  }

  @override
  Future<String?> downloadFile(String url) async {
    debugPrint('下载$url');
    String fileName = p.basename(url);
    String downUrl = "${environment.path.fileDownUrl}?fileName=$fileName&filePath=$url";
    html.AnchorElement downloadElemment = html.AnchorElement(href: downUrl);
    downloadElemment.download = downUrl;
    downloadElemment.click();
    downloadElemment.onClick.listen((event) {});
    return '';
  }

  @override
  String userAgent() {
    return html.window.navigator.userAgent;
  }

  Future _upload1(html.FileUploadInputElement uploadInput, html.Event event, Completer<String> completer) async {
    debugPrint('开始上传');
    // html.FileUploadInputElement uploadInput = event.target;
    final files = uploadInput.files;
    debugPrint('选择文件:$files');
    if (files != null && files.isNotEmpty) {
      // int ts = DateTime.now().millisecondsSinceEpoch;
      String uploadUrl = environment.path.fileUploadUrl;
      String requestURL = uploadUrl;
      debugPrint('上传的url:$requestURL');
      html.File? file = files.single;
      final html.FormData formData = html.FormData()
        ..append('fileName', file.name)
        ..append('mimeType', file.type)
        ..appendBlob('file', file.slice(), file.name);
      debugPrint('formData:$formData');
      html.HttpRequest.request(
        requestURL,
        method: 'POST',
        sendData: formData,
      ).then((html.HttpRequest httpRequest) {
        debugPrint('上传成功');
        String? response = httpRequest.responseText;
        Map? map = jsonDecode(response!);
        int? code = map?['code'];
        if (code == 0) {
          Map? data = map?['data'];
          String filePath = data?['fileName'];
          completer.complete(filePath);
        } else {
          String msg = map?['msg'];
          completer.completeError(msg);
        }
      }).catchError((e) {
        debugPrint('上传失败:$e');
        completer.completeError(e);
      });
    }
  }

  Future _upload(html.FileUploadInputElement uploadInput, html.Event event, Completer<String> completer) async {
    // html.FileUploadInputElement uploadInput = event.target;
    final files = uploadInput.files;
    debugPrint('选择文件:$files');
    if (files != null && files.isNotEmpty) {
      int ts = DateTime.now().millisecondsSinceEpoch;
      //先鉴权
      var authInfo = await getAuthenticationInfo('$ts');
      if (authInfo == null) {
        return;
      }
      // String downloadUrl = authInfo['downloadUrl'];
      String uploadUrl = authInfo['uploadUrl'];
      String accessId = authInfo['accessId'];
      String expireTime = authInfo['expireTime'];
      String signature = authInfo['signature'];
      String requestURL = '$uploadUrl?SDOSSAccessKeyId=$accessId&Expires=$expireTime&Signature=$signature';

      debugPrint('上传的url:$requestURL');

      html.File? file = files.single;
      final html.FormData formData = html.FormData()
        ..append('fileName', file.name)
        ..append('mimeType', file.type)
        ..appendBlob('file', file.slice(), file.name);
      debugPrint('formData:$formData');
      html.HttpRequest.request(
        requestURL,
        method: 'PUT',
        sendData: formData,
      ).then((httpRequest) {
        debugPrint('上传成功');
      }).catchError((e) {
        debugPrint('上传失败:$e');
      });
    }
  }

  ///获取认证url
  Future getAuthenticationInfo(String fileName) async {
    String authUrl = 'https://apicarrefourlsy.xx.com';
    if (environment.environment == Environment.sit) {
      authUrl = 'https://portalsit.xx.com';
    } else if (environment.environment == Environment.pre) {
      authUrl = 'https://portalpre.xx.com';
    }
    authUrl = '$authUrl/carrbshop-web/settle/ossAuthentication';

    debugPrint('上传地址:$authUrl');
    html.HttpRequest r = await html.HttpRequest.postFormData(authUrl, {'objectName': fileName}, responseType: 'json');
    if (r.response is! Map) {
      debugPrint('鉴权格式异常');
      return null;
    }
    Map result = r.response;
    debugPrint('鉴权信息:$result}');
    int? errorCode = int.tryParse(result['errorCode']);
    if (errorCode == null) {
      return null;
    }
    if (errorCode == 302) {
      debugPrint('登录超时');
      return null;
      // return {
      //   "downloadUrl":
      //       'http://sdosspre.xx.com/jlflserp/carrefour_common/1642413315',
      //   "accessId": '219K004828O05N5T',
      //   "signature": 'F5gsbk6aU7wOw%2BIlCMzxYL%2FXlDM%3D',
      //   "expireTime": '1642414898',
      //   "authorization": 'SDOSS 219K004828O05N5T:QdDuMJGalFZ7HjserzSl4ePQuns=',
      //   "uploadUrl":
      //       'http://sdossuppre.xx.com/jlflserp/carrefour_common/1642413315',
      //   "currentDate": 'Mon, 17 Jan 2022 09:51:38 GMT',
      // };
    }
    //正常请求
    int? code = int.tryParse(result['code']);
    if (code == 0 || code == 200) {
      debugPrint('鉴权成功');
      return result;
    }
    return null;
  }

  @override
  void clearCookies() {
    html.window.document.cookie = "";
  }

  @override
  void requestFullscreen(bool fullscreen) {
    if (fullscreen) {
      html.document.addEventListener('fullscreenchange', (event) {
        if (html.document.fullscreenElement != null) {
          print('111');
        } else {
          print('222');
        }
      });
      //no work
      // html.document.documentElement?.onFullscreenChange.listen((event) {
      //   if (html.document.fullscreenElement != null) {
      //     print('333');
      //   } else {
      //     print('444');
      //   }
      // });
      html.document.documentElement?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }
}
