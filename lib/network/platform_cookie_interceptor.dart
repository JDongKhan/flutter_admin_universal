import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

import 'network_utils.dart';

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
        _dealWithRedirect(response, handler).then((value) {
          //续期成功
          if (value) {
            //重新发起请求
            _resendRequest(response, handler);
          } else {
            //续期失败
            handler.reject(
              DioError(
                requestOptions: response.requestOptions,
                error: '登录异常',
              ),
            );
          }
        }).catchError((onError) {
          handler.reject(
            DioError(
              requestOptions: response.requestOptions,
              error: '登录异常',
            ),
          );
        });
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

    //flutter自己续期
    return false;
  }

  ///flutter 自己续期，便于自己单独跑的时候
  // Future<bool> _flutterRenewalCookies(String authStatusUrl) async {
  //   debugPrint('flutter续期开始...');
  //   // flutter层面的续302
  //   final BaseOptions baseOptions = BaseOptions(
  //     connectTimeout: 5000,
  //     receiveTimeout: 5000,
  //     sendTimeout: 5000,
  //     contentType: Headers.jsonContentType,
  //     responseType: ResponseType.json,
  //   );
  //   Dio dio = Network.getDio(baseOptions);
  //   Options options = Options();
  //   //开始重定向
  //   return _requestWithRedirect(dio, authStatusUrl, options).then((value) {
  //     String r = value.data;
  //     debugPrint('重定向后的cookie...');
  //     if (r.contains('"hasLogin":true')) {
  //       debugPrint('302重定向成功:${value.data}...');
  //       return true;
  //     } else {
  //       debugPrint('302重定向失败:${value.data}...');
  //       return false;
  //     }
  //   });
  // }

  Future<bool> _flutterRenewalCookies(String authStatusUrl) async {
    // ///开始续302
    final BaseOptions baseOptions = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      sendTimeout: 5000,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      maxRedirects: 20,
    );
    Dio dio = Network.getDio(baseOptions);
    Options options = Options();
    options.followRedirects = true;
    //开始续期

    return dio.get(authStatusUrl, options: options).then((value) {
      String r = value.data;
      if (r.contains('"hasLogin":true')) {
        debugPrint('302重定向成功:${value.data}...');
        return true;
      } else {
        debugPrint('302重定向失败:${value.data}...');
        return false;
      }
    });
  }

  ///重定向请求  自己模拟的重定向，因为dio get重定向会无限循环，暂时没有找到参数能解
  Future _requestWithRedirect(Dio dio, String? url, Options options) {
    // options ??= Options();
    options.responseType = ResponseType.plain;
    options.followRedirects = true;
    options.validateStatus = (status) {
      return status! < 500;
    };
    return dio.post(url!, options: options).then((value) {
      //获取response的cookies
      List<Cookie>? responseCookies = _getCookies(value);
      String newCookie = options.headers![HttpHeaders.cookieHeader];
      if (responseCookies != null && responseCookies.isNotEmpty) {
        //合并cookie
        newCookie = _mergeCookies(newCookie, responseCookies);
        //将cookie同步本地内存
        if (newCookie != null && newCookie.isNotEmpty) {
          PlatformCookieInterceptor.cookies = newCookie;
        }
      }
      if (value.statusCode == 302) {
        // String newCookie = getCookiesString(value);
        options.headers![HttpHeaders.cookieHeader] = newCookie;
        List<String>? location1 = value.headers[HttpHeaders.locationHeader];
        return _requestWithRedirect(dio, location1?.first, options);
      }
      return value;
    });
  }

  ///获取cookie
  List<Cookie>? _getCookies(Response response) {
    var cookies = response.headers[HttpHeaders.setCookieHeader];
    if (cookies != null) {
      List<Cookie> cs =
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList();
      return cs;
    }
    return null;
  }

  ///获取response里面的cookie
  // String _getCookiesString(Response response) {
  //   List<Cookie> cookies = _getCookies(response);
  //   String cookieString =
  //       cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  //   return cookieString;
  // }

  ///合并cookie
  String _mergeCookies(String requestCookies, List<Cookie> responseCookies) {
    List<String> c = requestCookies.split(';');
    List<Cookie> requestCookieList = [];
    for (var element in c) {
      List<String> l = element.split('=');
      String key = l.first;
      String value = l.last;
      key = key.trim();
      if (key.isNotEmpty) {
        Cookie cookie = Cookie(key, value.toString());
        requestCookieList.add(cookie);
      }
    }
    List newCookies = [];
    if (responseCookies != null) {
      for (Cookie rqCookie in requestCookieList) {
        bool canAdd = true;

        ///目的过滤
        for (Cookie resCookie in responseCookies) {
          if (rqCookie.name == resCookie.name && (resCookie.value).isNotEmpty) {
            canAdd = false;
          }
        }
        if (canAdd) {
          newCookies.add(rqCookie);
        }
      }
      newCookies.addAll(
          responseCookies.where((element) => (element.value).isNotEmpty));
    }
    String cookieString =
        newCookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    return cookieString;
  }

  ///重试原请求
  void _resendRequest(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint('开始重新请求：${response.requestOptions.path}...');
    RequestOptions requestOptions = response.requestOptions;
    Network.fetch(
      requestOptions.path,
      queryParameters: requestOptions.queryParameters,
      method: requestOptions.method,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      progressCallback: requestOptions.onReceiveProgress,
    ).then((value) {
      debugPrint('重试成功');
      dynamic data = value.data;
      response.data = data;
      response.statusCode = 200;
      handler.next(response);
    }).catchError((onError) {
      debugPrint('重试异常:${onError.toString()}');
      dynamic error = onError;
      if (onError is DioError) {
        error = onError.error;
      }
      handler.reject(
        DioError(requestOptions: requestOptions, error: error),
      );
    });
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
