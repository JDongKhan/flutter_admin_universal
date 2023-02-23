import '/service/path/log_path.dart';
import 'package:flutter_core/flutter_core.dart';

import '../service/environment.dart';
import 'model/log.dart';

class LogService {
  static Future<List<Log>?> list() {
    return Network.get(environment.path.logListUrl).then<List<Log>?>((value) {
      List list = value.data;
      return list.map((e) => Log.fromJson(e)).toList();
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }

  static Future<Map?> statisticsUrl() {
    return Network.get(environment.path.statisticsUrl).then<Map?>((value) {
      Map map = value.data;
      return map;
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }
}
