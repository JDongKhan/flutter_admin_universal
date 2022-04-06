import 'confoig/path_config.dart';

/// @author jd

enum Environment { prd, sit, pre }

Environments environment = Environments();

class Environments {
  void init({String env = 'prd'}) {
    if (env == 'sit') {
      environment = Environment.sit;
    } else if (env == 'pre') {
      environment = Environment.pre;
    } else {
      environment = Environment.prd;
    }
    path = PathConfig(environment);
  }

  Environment environment = Environment.prd;

  PathConfig path = PathConfig(Environment.prd);
}
