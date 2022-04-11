import 'package:flutter/foundation.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

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
  void selectFileAndUpload() {
    // TODO: implement selectFileAndUpload
  }

  @override
  void downloadFile(String url) {
    // TODO: implement downloadFile
  }

  @override
  String userAgent() {
    // TODO: implement userAgent
    throw UnimplementedError();
  }
}
