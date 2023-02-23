import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../platform/platform_adapter.dart';
import '../utils/navigation_util.dart';

///@author JD
class TokenInvalidInterceptor extends Interceptor {
  ///响应拦截
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map) {
      Map result = response.data;
      int? code = result['code'];
      //登录失效
      if (code == 403) {
        NavigationUtil.replace("/login");
        handler.reject(
          DioError(
            requestOptions: response.requestOptions,
            error: '登录超时，请重新登录',
          ),
        );
        return;
      } else {
        //正常请求
        if (code == 0 || code == 200) {
          debugPrint('请求成功');
          //请求成功
          dynamic d = result['data'];
          response.data = d;
        } else {
          //请求失败
          debugPrint('请求成功，业务异常');
          String message = result['msg'] ?? '服务异常';
          String code = result['code']?.toString() ?? '-999';
          message = '[$code]$message';
          // String
          handler.reject(
            DioError(
              requestOptions: response.requestOptions,
              error: message,
            ),
          );
          return;
        }
      }
    } else if (response.data == '') {
      handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          error: '返回数据异常',
        ),
      );
      return;
    }
    handler.next(response);
  }

  /// 处理302失效重定向
  Future<bool> _dealWithRedirect(
      Response response, ResponseInterceptorHandler handler) async {
    Map result = response.data;
    Map map = result['data'];
    String authStatusUrl = map['location'];
    debugPrint('开始302重定向:$authStatusUrl...');
    platformAdapter.login(authStatusUrl);
    handler.reject(
      DioError(
        requestOptions: response.requestOptions,
        error: '登录超时，请重新登录',
      ),
    );
    return false;
  }
}
