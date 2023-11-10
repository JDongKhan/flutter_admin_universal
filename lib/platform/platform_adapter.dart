import 'package:flutter/cupertino.dart';

import 'adapter/create_adapter.dart' if (dart.library.html) 'adapter/browser.dart' if (dart.library.io) 'adapter/io.dart';

/// @author jd

PlatformAdapter platformAdapter = createAdapter();

abstract class PlatformAdapter {
  @Deprecated("废弃了，请使用file_picker & dio")
  Future<String?> selectFileAndUpload();

  Future<String?> downloadFile(String url);

  void log(String message);

  void login(String url);

  String? cookies();

  void clearCookies();

  String userAgent();

  void alert(String message);

  void requestFullscreen(bool fullscreen);
}
