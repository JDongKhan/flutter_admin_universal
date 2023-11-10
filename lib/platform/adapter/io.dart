import 'dart:io';

import '/service/config/path_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import '../../service/environment.dart';
import '../platform_adapter.dart';

/// @author jd

PlatformAdapter createAdapter() => IOAdapter();

class IOAdapter implements PlatformAdapter {
  @override
  void log(String message) {
    debugPrint(message);
  }

  @override
  String? cookies() {
    throw UnimplementedError();
  }

  @override
  void login(String url) {
    // TODO: implement login
  }

  @override
  void alert(String message) {
    // TODO: implement alert
  }

  @override
  Future<String?> selectFileAndUpload() {
    return _uploadImage('');
  }

  @override
  Future<String?> downloadFile(String url) async {
    Directory? directory = await PathUtils.getAppCacheDirectory();
    String extension = p.extension(url);
    String fileName = p.basename(url);
    String newFileName = DateTime.now().millisecondsSinceEpoch.toString();
    String? savePath = directory?.path.appendUriPath("$newFileName$extension");
    File file = File(savePath!);
    if (file.existsSync()) {
      file.deleteSync();
    }
    _DownProgress progressChangeNotifier = _DownProgress();

    ToastUtils.showDialog(builder: (c) {
      return ChangeNotifierWidget<_DownProgress>(
        changeNotifier: progressChangeNotifier,
        builder: <_DownProgress>(c, c2) {
          return SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progressChangeNotifier._progress,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Colors.white,
            ),
          );
        },
      );
    });
    await Network.downloadFile(environment.path.fileDownUrl, savePath!,
        queryParameters: {
          "fileName": fileName,
          "filePath": url,
        },
        options: Options(), progressCallback: (int count, int total) {
      double progress = count * 1.0 / total * 1.0;
      print('contentLenght:$total');
      print('下载进度:$progress');
      progressChangeNotifier.update(progress);
      if (progress == 1.0) {
        ToastUtils.hiddenLoading();
      }
    });
    return savePath;
  }

  @override
  String userAgent() {
    // TODO: implement userAgent
    throw UnimplementedError();
  }

  Future _getAuthenticationInfo(String fileName) async {
    String authUrl = 'https://apicarrefourlsy.xx.com';
    if (environment.environment == Environment.sit) {
      authUrl = 'https://portalsit.xx.com';
    } else if (environment.environment == Environment.pre) {
      authUrl = 'https://portalpre.xx.com';
    }
    authUrl = '$authUrl/carrbshop-web/settle/ossAuthentication';
    await Network.post(authUrl, data: {'objectName': fileName});
    return null;
  }

  Future<String?> _uploadImage(String filePath) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    //先鉴权
    var authInfo = await _getAuthenticationInfo('$ts');
    if (authInfo == null) {
      return null;
    }
    String downloadUrl = authInfo['downloadUrl'];
    String uploadUrl = authInfo['uploadUrl'];
    String accessId = authInfo['accessId'];
    String expireTime = authInfo['expireTime'];
    String signature = authInfo['signature'];
    String requestURL = '$uploadUrl?SDOSSAccessKeyId=$accessId&Expires=$expireTime&Signature=$signature';

    // 单个文件上传
    var formData = FormData.fromMap({
      'name': 'file',
      'file': await MultipartFile.fromFile(
        filePath,
        filename: '$ts',
        contentType: MediaType('image', 'png'),
      ),
    });

    Network.put(requestURL, data: formData);
    return downloadUrl;
  }

  @override
  void clearCookies() {
    CookiesManager.getInstance().deleteAll();
  }

  @override
  void requestFullscreen(bool fullscreen) {}
}

class _DownProgress extends ChangeNotifier {
  double _progress = 0;

  void update(double progress) {
    _progress = progress;
    notifyListeners();
  }
}
