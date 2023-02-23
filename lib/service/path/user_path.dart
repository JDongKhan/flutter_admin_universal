import '../config/path_config.dart';

/// @author jd

extension UserPath on PathConfig {
  String get registerUrl => hostConfig.baseUrl.appendUriPath('/user/register');
  String get userListUrl => hostConfig.baseUrl.appendUriPath('/user/list');
  String get userById => hostConfig.baseUrl.appendUriPath('/user/queryById');
}
