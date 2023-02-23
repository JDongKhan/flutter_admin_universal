import '../environment.dart';
import 'host_config.dart';

/// @author jd

class PathConfig {
  PathConfig(Environment environment) {
    if (environment == Environment.sit) {
      hostConfig = SitHostConfig();
    } else if (environment == Environment.sit) {
      hostConfig = PreHostConfig();
    } else if (environment == Environment.local) {
      hostConfig = LocalHostConfig();
    } else {
      hostConfig = PrdHostConfig();
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
