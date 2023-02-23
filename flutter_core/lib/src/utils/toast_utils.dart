import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// @author jd
class ToastUtils {
  ///初始化
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return FlutterSmartDialog.init(builder: builder);
  }

  static NavigatorObserver observer() {
    return FlutterSmartDialog.observer;
  }

  static void showDialog({
    required WidgetBuilder builder,
  }) {
    SmartDialog.show(builder: builder);
  }

  static void showLoading() {
    SmartDialog.showLoading();
  }

  static void hiddenLoading() {
    SmartDialog.dismiss();
  }

  static void toast(dynamic msg) {
    msg ??= "未知信息";
    if (msg != null && msg is String) {
      SmartDialog.showToast(msg);
    } else {
      toastError(msg);
    }
  }

  static void toastError(onError) {
    String msg = '';
    if (onError is DioError) {
      msg = onError.error.toString();
    } else {
      msg = onError.toString();
    }
    SmartDialog.showToast(msg);
  }
}
