import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// @author jd
class PathUtils {
  static Future<Directory?> getAppDocumentsDirectory() async {
    if (kIsWeb) {
      return null;
    }
    if (Platform.isIOS || Platform.isAndroid) {
      return getApplicationDocumentsDirectory();
    }
    return null;
  }

  static Future<Directory?> getAppTemporaryDirectory() async {
    if (kIsWeb) {
      return null;
    }
    if (Platform.isIOS || Platform.isAndroid) {
      return getTemporaryDirectory();
    }
    return null;
  }

  static Future<Directory?> getAppCacheDirectory() async {
    if (kIsWeb) {
      return null;
    }
    if (Platform.isAndroid) {
      return getExternalStorageDirectory();
    }
    if (Platform.isIOS) {
      return getTemporaryDirectory();
    }
    return null;
  }
}
