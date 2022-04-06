import 'package:flutter/foundation.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

/// @author jd

PlatformAdapter createAdapter() => IOAdapter();

class IOAdapter implements PlatformAdapter {
  @override
  void log(String message) {
    debugPrint('我的是io端');
  }
}
