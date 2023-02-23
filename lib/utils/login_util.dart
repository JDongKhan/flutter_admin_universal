import '/platform/platform_adapter.dart';
import 'package:flutter_core/flutter_core.dart';

import '../http/model/user.dart';

/// @author jd

class LoginUtil {
  static bool isLoggedIn = false;
  static User? userInfo;
  static String userLoginKey = 'com.app.loginInfo';

  ///保存用户信息，这里可以使用cookie保存
  static void saveUserInfo(User user) {
    userInfo = user;
    SpUtils.putObject(userLoginKey, user.toJson());
    LoginUtil.isLoggedIn = true;
  }

  ///获取用户信息
  static User? getUserInfo() {
    if (userInfo == null) {
      Map? map = SpUtils.getObject(userLoginKey);
      if (map != null) {
        userInfo = User.fromJson(map);
      }
    }
    return userInfo;
  }

  ///退出
  static void logout() {
    userInfo = null;
    SpUtils.putObject(userLoginKey, null);
    //清理cookie
    platformAdapter.clearCookies();
  }
}
