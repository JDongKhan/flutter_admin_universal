import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// @author jd
class NetworkResponse {
  ///先使用NetworkResponse包装一下，以免未来需要额外能力
  NetworkResponse(this.data);

  ///数据
  dynamic data;
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Network {
  factory Network() => _instance;
  static final Network _instance = Network._internal();
  static Network getInstance() {
    return _instance;
  }

  Network._internal() {
    final BaseOptions options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      sendTimeout: 5000,
      //请求的contentType,默认值是'application/json;charset=utf-8'
      //自动编码请求体，防止有汉字
      // contentType: Headers.formUrlEncodedContentType,
      contentType: Headers.jsonContentType,
      //接受响应数据，可选json/strem/plain/bytes,默认是json
      responseType: ResponseType.json,
    );
    _dio = getDio(options);
    (_dio!.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  }

  Dio? _dio;

  static bool retryEnable = false;

  ///添加拦截器
  static void init({List<Interceptor> interceptors = const <Interceptor>[]}) {
    Dio dio = getInstance()._dio!;
    dio.interceptors..addAll(interceptors);
  }

  ///新建dio
  static Dio getDio([BaseOptions? baseOptions]) {
    Dio dio = Dio(baseOptions);
    return dio;
  }

  /// get请求
  static Future<NetworkResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    String? contentType,
    bool cache = false,
    bool mock = false,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      queryParameters: queryParameters,
      method: 'GET',
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// post请求
  /*
  data，会写入到body里面
  queryParameters是拼接到url里面的
  * */
  static Future<NetworkResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
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
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
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
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
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
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
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
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    return await fetch(
      url,
      method: 'HEAD',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      contentType: contentType,
      cancelToken: cancelToken,
      cache: cache,
      mock: mock,
      progressCallback: progressCallback,
    );
  }

  /// 下载文件
  static Future<dynamic> downloadFile(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    dynamic data,
    Options? options,
    ProgressCallback? progressCallback,
  }) async {
    //进度
    Response response = await Network.getInstance()._dio!.download(
        urlPath, savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        data: data,
        options: options, onReceiveProgress: (int count, int total) {
      if (progressCallback != null) {
        progressCallback(count, total);
      }
    });
    return response.data;
  }

  /// 文件上传
  static Future<dynamic> uploadFile(String url, List<String> images,
      {Map? params}) async {
    // var formData = FormData.fromMap({
    //   'name': 'wendux',
    //   'age': 25,
    //   'file': await MultipartFile.fromFile('./text.txt', filename: 'upload.txt'),
    //   'files': [
    //     await MultipartFile.fromFile('./text1.txt', filename: 'text1.txt'),
    //     await MultipartFile.fromFile('./text2.txt', filename: 'text2.txt'),
    //   ]
    // });
    //

    Map formData = {};
    if (params != null) {
      formData.addAll(params);
    }
    if (images.length == 1) {
      formData['file'] = await MultipartFile.fromFile(images.first);
    } else {
      formData['files'] = images
          .map((e) async => await MultipartFile.fromFile(images.first))
          .toList();
    }
    Response response =
        await Network.getInstance()._dio!.post<String>(url, data: formData);
    return response;
  }

  ///请求处理
  static Future<NetworkResponse> fetch(
    String url, {
    String method = 'GET',
    //data 可传FormData
    dynamic data,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    String? contentType,
    CancelToken? cancelToken,
    bool cache = false,
    bool mock = false,
    ProgressCallback? progressCallback,
  }) async {
    Options options = Options();
    options.contentType = contentType;
    options.responseType = responseType ?? ResponseType.json;
    options.method = method;
    options.extra ??= <String, dynamic>{};
    options.headers ??= <String, dynamic>{};
    //添加额外参数
    options.extra!.addAll(<String, dynamic>{'noCache': cache, 'mock': mock});
    //进度
    ProgressCallback callback;
    callback = (int count, int total) {
      if (progressCallback != null) {
        progressCallback(count, total);
      }
    };

    if (method == 'GET') {
      //Get请求
      // String fullPath = url;
      // if (queryParameters != null && queryParameters.isNotEmpty) {
      //   final List<String> params = [];
      //   queryParameters.forEach((String key, dynamic value) {
      //     params.add('$key=$value');
      //   });
      //   fullPath += '?' + params.join(',');
      // }
      // url = fullPath;
      // Response r = await Network.getInstance()._dio.get(url, options: options);
      // return NetworkResponse(0, data: r.data);
    } else if (method == 'POST') {
      // Response r = await Network.getInstance()
      //     ._dio
      //     .post(url, data: data, cancelToken: cancelToken, options: options);
      // return NetworkResponse(r.data);
    }

    Response r = await Network.getInstance()._dio!.request(
          url,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onReceiveProgress: callback,
        );
    //r.data 响应体
    //r.header 响应头
    //r.request 请求体
    //r.statusCode 状态码
    return NetworkResponse(r.data);
  }
}
