import 'package:dio/dio.dart';

///@Description TODO
///@Author jd

/// [LogInterceptor] is used to print logs during network requests.
/// It's better to add [LogInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class MyLogInterceptor extends Interceptor {
  MyLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    StringBuffer logString = StringBuffer('\n*** Request *** \n');
    logString.write(_getKVString('uri', options.uri));
    //options.headers;

    if (request) {
      logString.write(_getKVString('method', options.method));
      logString
          .write(_getKVString('responseType', options.responseType.toString()));
      logString.write(_getKVString('followRedirects', options.followRedirects));
      logString.write(_getKVString('connectTimeout', options.connectTimeout));
      logString.write(_getKVString('sendTimeout', options.sendTimeout));
      logString.write(_getKVString('receiveTimeout', options.receiveTimeout));
      logString.write(_getKVString(
          'receiveDataWhenStatusError', options.receiveDataWhenStatusError));
      logString.write(_getKVString('extra', options.extra));
    }
    if (requestHeader) {
      logString.write(_getKVString('headers', ''));
      options.headers
          .forEach((key, v) => logString.write(_getKVString(key, v)));
    }
    if (requestBody) {
      logString.write(_getKVString('data', ''));
      options.data.toString().split('\n').forEach((value) {
        logString.write(_longLogString(value));
      });
    }
    logPrint(logString);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _printResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (error) {
      StringBuffer logString = StringBuffer('\n*** DioError ***: \n');
      logString.write('uri: ${err.requestOptions.uri}\n');
      logString.write('$err');
      if (err.response != null) {
        _printResponse(err.response!);
      }
      logPrint(logString);
    }

    handler.next(err);
  }

  void _printResponse(Response response) {
    StringBuffer logString = StringBuffer('\n*** Response *** \n');
    logString.write(_getKVString('uri', response.requestOptions.uri));
    if (responseHeader) {
      logString.write(_getKVString('statusCode', response.statusCode));
      if (response.isRedirect == true) {
        logString.write(_getKVString('redirect', response.realUri));
      }
      logString.write(_getKVString('headers', ''));

      response.headers.forEach(
        (key, v) => logString.write(
          _getKVString(
            ' $key',
            v.join('\r\n\t'),
          ),
        ),
      );
    }
    if (responseBody) {
      logString.write(_getKVString('Response Text', ''));
      response.toString().split('\n').forEach((value) {
        logString.write(_longLogString(value));
      });
    }
    logPrint(logString);
  }

  String _getKVString(String key, Object? v) {
    return '$key: $v \n';
  }

  StringBuffer _longLogString(String log) {
    StringBuffer stringBuffer = StringBuffer();
    int maxLength = 800;
    String remainString = log;
    while (remainString != null && remainString.isNotEmpty) {
      int length = maxLength;
      if (remainString.length < maxLength) {
        length = remainString.length;
      }
      String subString = remainString.substring(0, length);
      stringBuffer.write(subString);
      remainString = remainString.substring(length, remainString.length);
      if (remainString != null && remainString.isNotEmpty) {
        stringBuffer.write('\n');
      }
    }
    return stringBuffer;
  }
}
