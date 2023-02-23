import '../config/path_config.dart';

/// @author jd

extension UserPath on PathConfig {
  String get logListUrl => hostConfig.baseUrl.appendUriPath('/log/allLog');
  String get statisticsUrl =>
      hostConfig.baseUrl.appendUriPath('/log/statistics');
}
