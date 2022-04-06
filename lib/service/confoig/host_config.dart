/// @author jd

abstract class HostConfig {
  String get baseUrl;
}

class PrdHostConfig implements HostConfig {
  @override
  String get baseUrl => 'https://baidu.com';
}

class SitHostConfig implements HostConfig {
  @override
  String get baseUrl => 'https://baidu.com';
}

class PreHostConfig implements HostConfig {
  @override
  String get baseUrl => 'https://baidu.com';
}

class LocalHostConfig implements HostConfig {
  LocalHostConfig() {
    init();
  }

  void init() async {}

  @override
  String get baseUrl => 'https://baidu.com';
}
