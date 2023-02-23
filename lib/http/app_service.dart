import '/http/model/release_info.dart';
import 'package:flutter_core/flutter_core.dart';

import '../service/environment.dart';

class AppService {
  ///查询单个应用
  static Future<ReleaseInfo?> add(String name, String path, String info) {
    return Network.post(environment.path.addAppUrl, data: {
      "name": name,
      "path": path,
      "info": info,
      "flag": 0,
    }).then<ReleaseInfo?>((value) {
      Map map = value.data;
      ToastUtils.toast('添加成功');
      return ReleaseInfo.fromJson(map);
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }

  ///删除单个应用
  static Future<bool> deleteById(int id) {
    return Network.get(environment.path.deleteAppById,
        queryParameters: {'id': id}).then((value) {
      ToastUtils.toast('删除成功');
      return true;
    }).catchError((error) {
      ToastUtils.toastError(error);
      return false;
    });
  }

  ///应用列表
  static Future<List<ReleaseInfo>?> list() {
    return Network.get(environment.path.appListUrl)
        .then<List<ReleaseInfo>?>((value) {
      List list = value.data;
      return list.map((e) => ReleaseInfo.fromJson(e)).toList();
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }

  ///查询单个应用
  static Future<ReleaseInfo?> queryById(int id) {
    return Network.post(environment.path.appById, queryParameters: {'id': id})
        .then<ReleaseInfo?>((value) {
      Map map = value.data;
      return ReleaseInfo.fromJson(map);
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }
}
