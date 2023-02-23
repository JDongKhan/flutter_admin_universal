import 'package:app_installer/app_installer.dart';
import 'package:flutter/foundation.dart';

class AppUtils {
  static void installApp(String url) {
    if (!kIsWeb) {
      AppInstaller.installApk(url);
    }
  }
}
