import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import '../utils/toast_utils.dart';
import 'cookie_manager.dart';
import 'error_interceptor.dart';
import 'mock_interceptor.dart';
import 'retry_interceptor.dart';

/// @author jd
class NetworkResponse {
  NetworkResponse(this.code, {this.errorMsg, this.data});
  int code;
  String? errorMsg;
  dynamic data;
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Network {
  //单例
  factory Network() => getInstance();
  static Network? _instance;
  static Network getInstance() {
    _instance ??= Network._();
    return _instance!;
  }

  Network._() {
    //https://github.com/flutterchina/dio/issues/1027 cookie
    final BaseOptions options = BaseOptions(
      extra: {"withCredentials": true},
      connectTimeout: 20000,
      receiveTimeout: 3000,
      //请求的contentType,默认值是'application/json;charset=utf-8'
      //自动编码请求体，防止有汉字
      contentType: Headers.jsonContentType,
      //接受响应数据，可选json/strem/plain/bytes,默认是json
      responseType: ResponseType.json,
    );
    _dio = Dio(options);
    _dio!.interceptors
      ..add(NetworkMockInterceptor())
      ..add(ErrorInterceptor())
      ..add(DioCacheManager(CacheConfig()).interceptor as Interceptor)
      ..add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    if (kIsWeb) {
    } else if (Platform.isAndroid || Platform.isIOS) {
      //iOS和Android才支持本地目录
      _dio!.interceptors.add(
        CookieManager(CookiesManager.getInstance().cookieJar),
      );
    }
    (_dio!.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    //重试逻辑
    if (retryEnable) {
      _dio!.interceptors.add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: _dio!,
            connectivity: Connectivity(),
          ),
        ),
      );
    }
    _fetchTypes.addAll({
      'post': _dio!.post,
      'put': _dio!.put,
      'patch': _dio!.patch,
      'delete': _dio!.delete,
      'head': _dio!.head,
    });
  }

  static bool retryEnable = false;
  CancelToken cancelToken = CancelToken();
  Dio? _dio;
  //是否是魔客
  static const bool _mock = true;
  static String? _proxyIpAddress;

  String? getProxyIpAddress() => _proxyIpAddress;

  void setProxyIpAddress(String ip) {
    _proxyIpAddress = ip;
    if (_proxyIpAddress != null) {
      (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return 'PROXY ${_proxyIpAddress!}';
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  static void addInterceptor(Interceptor interceptor) {
    Network.getInstance()._dio?.interceptors.add(interceptor);
  }

  /// get请求
  static Future<NetworkResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// post请求
  static Future<NetworkResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      method: 'post',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// put请求
  static Future<NetworkResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      method: 'put',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// patch请求
  static Future<NetworkResponse> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      method: 'patch',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// delete请求
  static Future<NetworkResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      method: 'delete',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// head请求
  static Future<NetworkResponse> head(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await Network.getInstance()._fetch(
      url,
      method: 'head',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// 下载文件
  static Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    dynamic data,
    Options? options,
    ProgressCallback? progressCallback,
  }) async {
    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    Response response = await Network.getInstance()._dio!.download(
        urlPath, savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        data: data,
        options: options,
        onReceiveProgress: callback);
    return response;
  }

  /// 上传文件
  static Future<Response> uploadFile(
    String urlPath,
    String filePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? progressCallback,
  }) async {
    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    // 单个文件上传
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(filePath, filename: 'file')});
// 多个文件上传
//     var formData =  FormData.fromMap({
//       'files': [
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//       ]
//     });
    Response response = await Network.getInstance()._dio!.post(urlPath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        data: formData,
        options: options,
        onReceiveProgress: callback);
    return response;
  }

  ///取消请求，会取消所有使用cancelToken的请求，慎用！！！，如需要取消某一个，可自行管理
  static void cancel() {
    Network.getInstance().cancelToken.cancel('用户手动取消');
  }

  final Map<String, Function> _fetchTypes = {};

  ///请求处理
  Future<NetworkResponse> _fetch(
    String url, {
    String method = 'get',
    //data 可传FormData
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    final ConnectivityResult connResult =
        await Connectivity().checkConnectivity();
    if (connResult == ConnectivityResult.none) {
      ToastUtils.toast('网络连接失败');
      // throw DioError(error: JDUnreachableNetworkException());
    }

    options = options ?? Options();
    //添加额外参数
    options.extra = (options.extra ?? {})
      ..addAll(<String, dynamic>{'noCache': cache, 'mock': mock && _mock});
    //添加公共参数
    options.headers = (options.headers ?? {})
      ..addAll({
        'userAgent': 'MyApp',
      });

    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    // ignore: always_specify_types
    Response r;
    if (method == 'get') {
      //Get请求
      r = await Network.getInstance()._dio!.get<dynamic>(
            url,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: callback,
          );
    } else {
      //Post等其他请求
      r = await _fetchTypes[method]!<dynamic>(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: callback);
    }
    //r.data 响应体
    //r.header 响应头
    //r.request 请求体
    //r.statusCode 状态码
    return NetworkResponse(0, data: r.data);
  }
}
