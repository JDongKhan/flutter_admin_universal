import 'package:flutter/foundation.dart';
import 'package:flutter_admin_universal/service/environment.dart';

import 'host_config.dart';

/// @author jd

class PathConfig {
  PathConfig(Environment environment) {
    if (kIsWeb && kDebugMode) {
      hostConfig = LocalHostConfig();
    } else {
      if (environment == Environment.sit) {
        hostConfig = SitHostConfig();
      } else if (environment == Environment.sit) {
        hostConfig = PreHostConfig();
      } else {
        hostConfig = PrdHostConfig();
      }
    }
  }
  HostConfig hostConfig = PrdHostConfig();
}

extension PathExtendsion on String {
  String appendUriPath(String path) {
    if (endsWith('/') || path.startsWith('/')) {
      return '${this}$path';
    }
    return '$this/$path';
  }
}
