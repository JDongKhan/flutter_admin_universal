import 'package:flutter/foundation.dart';

/// @author jd

abstract class HostConfig {
  String get baseUrl;
}

class PrdHostConfig implements HostConfig {
  @override
  String get baseUrl =>
      kIsWeb ? '/dispatcher' : 'http://10.24.44.63:8001/dispatcher';
}

class SitHostConfig implements HostConfig {
  @override
  String get baseUrl => 'http://10.24.44.63:8001/dispatcher';
}

class PreHostConfig implements HostConfig {
  @override
  String get baseUrl => 'http://10.24.44.63:8001/dispatcher';
}

class LocalHostConfig implements HostConfig {
  LocalHostConfig() {
    init();
  }

  void init() async {}

  @override
  String get baseUrl => 'http://jd.xx.com:8001/dispatcher';
}
