import 'package:flutter_admin_universal/service/confoig/path_config.dart';

/// @author jd

extension LoginPath on PathConfig {
  String get loginUrl => hostConfig.baseUrl.appendUriPath('/login');
}
