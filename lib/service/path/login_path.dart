import '../config/path_config.dart';

/// @author jd

extension LoginPath on PathConfig {
  String get loginUrl => hostConfig.baseUrl.appendUriPath('/user/login');
  String get logoutUrl => hostConfig.baseUrl.appendUriPath('/user/logout');
  String get authAccess =>
      hostConfig.baseUrl.appendUriPath('sample/test/authAccess');
}
