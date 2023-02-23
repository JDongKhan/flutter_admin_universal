import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

class CrashUtils {
  ///搜集日志
  static void collect(
    void Function() rubBody,
    void Function()? platformCatchBody,
  ) {
    if (kIsWeb) {
      configCollect();
      runZonedGuarded(() {
        rubBody();
      }, (error, stackTrace) {
        //TODO 此处可以上传到自己的服务器
        FlutterError.presentError(
            FlutterErrorDetails(exception: error, stack: stackTrace));
        reportErrorAndLog(error, stackTrace);
      });
    } else if (Platform.isAndroid || Platform.isIOS) {
      if (platformCatchBody != null) {
        platformCatchBody();
      } else {
        rubBody();
      }
    } else {
      configCollect();
      runZonedGuarded(() {
        rubBody();
      }, (error, stackTrace) {
        //TODO 此处可以上传到自己的服务器
        FlutterError.presentError(
            FlutterErrorDetails(exception: error, stack: stackTrace));
        reportErrorAndLog(error, stackTrace);
      });
    }
  }
}

void configCollect() {
  //TODO 3.3以上版本支持下面代码 https://flutter.cn/docs/testing/errors
  //非flutter导致的异常，如MethodChannel.invokeMethod 调用时发生的异常
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.presentError(
        FlutterErrorDetails(exception: error, stack: stack));
    reportErrorAndLog(error, stack);
    return true;
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (details.stack != null) {
      reportErrorAndLog(details.exception, details.stack);
      // Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
}

///收集崩溃
void reportErrorAndLog(Object error, StackTrace? stackTrace) {
  // 上报错误和日志逻辑
  // print(details);
}
