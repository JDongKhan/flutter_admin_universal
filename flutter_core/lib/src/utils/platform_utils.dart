import 'package:flutter/foundation.dart';

class PlatformUtils {
  static final bool isMacOS =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static final bool isAndroid =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static final bool isIOS =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static final bool isFuchsia =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.fuchsia;
  static final bool isWindows =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static final bool isLinux =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
  static const bool isWeb = kIsWeb;
}
