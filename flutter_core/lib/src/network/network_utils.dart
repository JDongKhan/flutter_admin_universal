import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_core/src/network/my_log_interceptor.dart';

import '../../flutter_core.dart';
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
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
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
      ..add(MyLogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: logger.v,
        error: true,
      ));
    if (kIsWeb) {
    } else if (Platform.isAndroid || Platform.isIOS) {
      //iOS和Android才支持本地目录
      _dio!.interceptors.add(
        CookieManager(CookiesManager.getInstance().cookieJar),
      );
    }
    (_dio!.transformer as SyncTransformer).jsonDecodeCallback = parseJson;
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
  static String userAgent = 'MyApp';

  String? getProxyIpAddress() => _proxyIpAddress;

  void setProxyIpAddress(String ip) {
    _proxyIpAddress = ip;
    if (_proxyIpAddress != null) {
      (_dio!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
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

  static void addInterceptor(
    Interceptor interceptor, {
    bool beforeLog = false,
  }) {
    if (beforeLog) {
      Interceptors? interceptors = Network.getInstance()._dio?.interceptors;
      int logIndex =
          interceptors?.indexWhere((element) => element is MyLogInterceptor) ??
              0;
      Network.getInstance()._dio?.interceptors.insert(logIndex, interceptor);
    } else {
      Network.getInstance()._dio?.interceptors.add(interceptor);
    }
  }

  /// get请求
  static Future<NetworkResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      queryParameters: queryParameters,
      contentType: contentType,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// post请求
  /// queryParameters url拼接的参数
  /// data body里面的内容 一般是json
  static Future<NetworkResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'post',
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// put请求
  /// queryParameters url拼接的参数
  //  data body里面的内容 一般是json
  static Future<NetworkResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'put',
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
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
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'patch',
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
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
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'delete',
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
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
    String? contentType,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'head',
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
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
  static Future<NetworkResponse> uploadFile(
    String urlPath,
    String filePath, {
    Map<String, dynamic>? form,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? contentType,
    ProgressCallback? progressCallback,
  }) async {
    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    // 单个文件上传
    var formData = FormData.fromMap(
      {
        'file': await MultipartFile.fromFile(filePath),
      }..addAll(form ?? {}),
    );
// 多个文件上传
//     var formData =  FormData.fromMap({
//       'files': [
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//       ]
//     });
    NetworkResponse response = await Network.post(
      urlPath,
      queryParameters: queryParameters,
      data: formData,
      contentType: contentType,
      progressCallback: callback,
    );
    return response;
  }

  static Future<NetworkResponse> uploadFileBytes(
    String urlPath,
    List<int> value, {
    Map<String, dynamic>? form,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? contentType,
    ProgressCallback? progressCallback,
  }) async {
    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    // 单个文件上传
    var formData = FormData.fromMap(
      {
        'file': MultipartFile.fromBytes(value),
      }..addAll(form ?? {}),
    );
// 多个文件上传
//     var formData =  FormData.fromMap({
//       'files': [
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//         MultipartFile.fromFileSync('./example/upload.txt',
//             filename: 'upload.txt'),
//       ]
//     });
    NetworkResponse response = await Network.post(
      urlPath,
      queryParameters: queryParameters,
      data: formData,
      contentType: contentType,
      progressCallback: callback,
    );
    return response;
  }

  ///取消请求，会取消所有使用cancelToken的请求，慎用！！！，如需要取消某一个，可自行管理
  static void cancel() {
    Network.getInstance().cancelToken.cancel('用户手动取消');
  }

  final Map<String, Function> _fetchTypes = {};

  ///请求处理
  /// queryParameters url拼接的参数
  /// data body里面的内容 一般是json
  static Future<NetworkResponse> fetch(
    String url, {
    String method = 'get',
    //data 可传FormData
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool cache = false,
    bool mock = false,
    String? contentType,
    ProgressCallback? progressCallback,
  }) async {
    if (!(mock && _mock)) {
      final ConnectivityResult connResult =
          await Connectivity().checkConnectivity();
      if (connResult == ConnectivityResult.none) {
        ToastUtils.toast('网络连接失败');
        throw UnreachableNetworkException(
          requestOptions: RequestOptions(path: url, method: method),
        );
      }
    }

    Options options = Options();
    //添加额外参数
    options.extra = (options.extra ?? {})
      ..addAll(<String, dynamic>{
        'noCache': cache,
        'mock': mock && _mock,
      });
    //添加公共参数
    options.headers = (options.headers ?? {})
      ..addAll({
        'userAgent': userAgent,
      });

    options.contentType = contentType;
    //进度
    callback(int count, int total) {
      progressCallback?.call(count, total);
    }

    // ignore: always_specify_types
    Response r;
    String lowerMethod = method.toLowerCase();
    if (lowerMethod == 'get') {
      //Get请求
      r = await Network.getInstance()._dio!.get<dynamic>(
            url,
            queryParameters: queryParameters,
            options: options,
            cancelToken: Network.getInstance().cancelToken,
            onReceiveProgress: callback,
          );
    } else {
      //Post等其他请求
      r = await Network.getInstance()._fetchTypes[lowerMethod]!<dynamic>(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: Network.getInstance().cancelToken,
          onReceiveProgress: callback);
    }
    //r.data 响应体
    //r.header 响应头
    //r.request 请求体
    //r.statusCode 状态码
    return NetworkResponse(0, data: r.data);
  }
}
