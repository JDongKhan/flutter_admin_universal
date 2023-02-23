import 'dart:async';

import 'package:flutter_core/flutter_core.dart';

import 'model/user.dart';
import '../service/environment.dart';
import '../utils/login_util.dart';

class UserService {
  ///登录
  static Future<User?> login(String account, String password) {
    return Network.post(environment.path.loginUrl,
        data: {"account": account, "password": password}).then<User?>((value) {
      User user = User.fromJson(value.data);
      LoginUtil.saveUserInfo(user);
      return user;
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }

  ///退出
  static Future logout() {
    return Network.get(environment.path.logoutUrl).then((value) {
      return value.data;
    });
  }

  ///用户列表
  static Future<List<User>?> list() {
    return Network.get(environment.path.userListUrl).then<List<User>?>((value) {
      List list = value.data;
      return list.map((e) => User.fromJson(e)).toList();
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }

  ///查询单个用户
  static Future<User?> queryById(int id) {
    return Network.get(environment.path.userById, queryParameters: {'id': id})
        .then<User?>((value) {
      Map map = value.data;
      return User.fromJson(map);
    }).catchError((error) {
      ToastUtils.toastError(error);
      return null;
    });
  }
}
