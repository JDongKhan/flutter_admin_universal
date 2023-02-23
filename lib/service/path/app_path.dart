import '../config/path_config.dart';

/// @author jd

extension AppPath on PathConfig {
  String get addAppUrl => hostConfig.baseUrl.appendUriPath('/release/add');
  String get deleteAppById =>
      hostConfig.baseUrl.appendUriPath('/release/deleteById');
  String get appListUrl => hostConfig.baseUrl.appendUriPath('/release/list');
  String get appById => hostConfig.baseUrl.appendUriPath('/release/queryById');
  String get fileDownUrl =>
      hostConfig.baseUrl.appendUriPath('/common/downloadFile');
  String get fileUploadUrl =>
      hostConfig.baseUrl.appendUriPath('/common/upload');
}
