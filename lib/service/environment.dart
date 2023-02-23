import 'package:flutter/foundation.dart';

import 'config/path_config.dart';
export 'path/login_path.dart';
export 'path/user_path.dart';
export 'path/app_path.dart';

/// @author jd

enum Environment { prd, local, sit, pre }

Environments environment = Environments();

class Environments {
  ///初始化环境变量
  void initWithName({String env = 'prd'}) {
    Environment environment = Environment.prd;
    if (env == 'sit') {
      environment = Environment.sit;
    } else if (env == 'pre') {
      environment = Environment.pre;
    } else if (env == 'local') {
      environment = Environment.local;
    } else {
      environment = Environment.prd;
    }
    init(environment);
  }

  ///初始化环境变量
  void init(Environment env) {
    environment = env;
    if (kDebugMode && kIsWeb) {
      environment = Environment.local;
    }
    path = PathConfig(environment);
  }

  Environment environment = Environment.prd;

  PathConfig path = PathConfig(Environment.prd);
}
