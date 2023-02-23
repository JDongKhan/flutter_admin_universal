import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../flutter_core.dart';

/// @author jd
///

class AppInfo {
  /// 临时目录 eg: cookie
  static Directory? temporaryDirectory;
  //初始化
  static Future init({
    List<DeviceOrientation> orientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ],
  }) {
    WidgetsFlutterBinding.ensureInitialized();
    //添加日志处理 先初始化日志
    LogOutputManager.getInstance();
    _config(orientations);
    //异步初始化
    return AppInfo.delayInit();
  }

  static void _config(List<DeviceOrientation> orientations) {
    if (kIsWeb) {
      //支持web
    } else {
      //强制竖屏
      SystemChrome.setPreferredOrientations(orientations);
      //android特殊配置
      if (Platform.isAndroid) {
        ///沉浸式能力由原生实现
        // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        const SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

        // var darkMode = window.platformBrightness == Brightness.dark;
        //
        // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        // final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        // final bool edgeToEdge = androidInfo.version.sdkInt != null &&
        //     androidInfo.version.sdkInt! >= 29;
        //
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        //
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        //   systemNavigationBarColor: edgeToEdge
        //       ? Colors.transparent
        //       : darkMode
        //           ? Colors.black
        //           : Colors.white,
        //   systemNavigationBarContrastEnforced: true,
        //   systemNavigationBarIconBrightness:
        //       darkMode ? Brightness.light : Brightness.dark,
        // ));
      }
    }
  }

  //初始化全局信息
  // ignore: always_specify_types
  static Future delayInit() async {
    temporaryDirectory = await PathUtils.getAppTemporaryDirectory();
    //初始化bugly
//    FlutterBugly.init(androidAppId: "your android app id",iOSAppId: "your iOS app id");
//    FlutterBugly.setUserId("user id");
//    FlutterBugly.putUserData(key: "key", value: "value");
//    int tag = 9527;
//    FlutterBugly.setUserTag(tag);
//
    return SpUtils.init();
  }

  //隐藏显示状态栏
  static void toggleFullScreen(bool fullscreen) {
    fullscreen
        ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [])
        : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
  }

  static void setup(BuildContext context) async {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);
  }
}
