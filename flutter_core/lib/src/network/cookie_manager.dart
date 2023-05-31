import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';

import '../utils/app_info.dart';

///@Description TODO
///@Author jd

class CookiesManager {
  CookiesManager._();
  factory CookiesManager() => getInstance();
  static CookiesManager? _instance;
  static CookiesManager getInstance() {
    return _instance ?? CookiesManager._();
  }

  PersistCookieJar? _cookieJar;
  PersistCookieJar get cookieJar => _cookieJar = _cookieJar ??
      PersistCookieJar(
        storage: FileStorage(AppInfo.temporaryDirectory!.path),
      );

  Future<List<Cookie>>? loadForRequest(Uri uri) {
    return _cookieJar?.loadForRequest(uri);
  }

  Future deleteAll() async {
    return await _cookieJar?.deleteAll();
  }
}
