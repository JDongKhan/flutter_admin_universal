import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

///@author JD
class PlatformCookieInterceptor extends Interceptor {
  static String? cookies;

  ///请求拦截
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String? cookie = platformAdapter.cookies();
    debugPrint('获取cookies:$cookie');
    handler.next(options);
  }

  ///响应拦截
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponse(response);
    if (response.data is Map) {
      Map result = response.data;
      int? errorCode = int.tryParse(result['errorCode']);
      //登录失效
      if (errorCode == 302) {
        _printResponse(response);
        debugPrint('登录超时,开始续期重新请求');
        // PlatformUtils.login();
        // handler.reject(
        //   DioError(
        //     requestOptions: response.requestOptions,
        //     error: '登录超时',
        //   ),
        // );
        //续期登录
        _dealWithRedirect(response, handler);
        return;
      } else {
        //正常请求
        int? code = int.tryParse(result['code']);
        if (code == 0 || code == 200) {
          debugPrint('请求成功');
          //请求成功
          dynamic d = result['data'];
          response.data = d;
        } else {
          //请求失败
          debugPrint('请求成功，业务异常');
          _printResponse(response);
          String message = result['message'] ?? '服务异常';
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
      _printResponse(response);
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
    //flutter自己续期
    return false;
  }

  /// 日志
  void _printResponse(Response response) {
    debugPrint('*** Response ***');
    _printKV('uri', response.requestOptions.uri);
    _printKV('statusCode', response.statusCode ?? 0);
    if (response.isRedirect == true) {
      _printKV('redirect', response.realUri);
    }

    debugPrint('headers:');
    response.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t')));
    debugPrint('Response Text:');
    _printAll(response.toString());
    debugPrint('');
  }

  void _printKV(String key, Object v) {
    debugPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(debugPrint);
  }
}
