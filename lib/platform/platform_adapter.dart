import 'adapter/create_adapter.dart'
    if (dart.library.html) 'adapter/browser.dart'
    if (dart.library.io) 'adapter/io.dart';

/// @author jd

PlatformAdapter platformAdapter = createAdapter();

abstract class PlatformAdapter {
  void selectFileAndUpload();

  void downloadFile(String url);

  void log(String message);

  void login(String url);

  String? cookies();

  String userAgent();

  void alert(String message);
}
