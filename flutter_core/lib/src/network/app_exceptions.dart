import 'package:dio/dio.dart';

///@author JD
/// 自定义异常
class AppException extends DioError {
  static const cancel = '请求取消';
  static const connectTimeout = '连接超时';
  static const sendTimeout = '请求超时';
  static const receiveTimeout = '响应超时';
  static const syntaxError = '请求语法错误';
  static const notAuthorized = '没有权限';
  static const serviceRefuse = '服务器拒绝执行';
  static const notFoundService = '请求服务不存在';
  static const requestForbidden = '请求方法被禁止';
  static const serverInternalError = '服务器内部错误';
  static const requestInvalid = '网关错误';
  static const serverShutdown = '服务不可用';
  static const unsupportedHTTPProtocol = '不支持该版本的HTTP协议请求';
  static const unknownError = '未知错误';
  static const networkUnreachable = '网络连接失败';
  static const clientError = '客户端逻辑出错';
  static const serviceError = '服务内部异常';
  static const clientRequestError = '客户端请求处理异常';
  static const clientResponseError = '客户端响应处理异常';
  static const loginCookieInvalid = '登录超时';

  final int code;
  AppException({
    required super.requestOptions,
    required this.code,
    super.response,
    super.error,
    super.message,
  });

  factory AppException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return AppException(
            code: -1,
            requestOptions: error.requestOptions,
            message: cancel,
            error: error.error,
            response: error.response,
          );
        }
      case DioErrorType.connectionTimeout:
        {
          return AppException(
            code: -1,
            requestOptions: error.requestOptions,
            message: connectTimeout,
            error: error.error,
            response: error.response,
          );
        }
      case DioErrorType.sendTimeout:
        {
          return AppException(
            code: -1,
            requestOptions: error.requestOptions,
            message: sendTimeout,
            error: error.error,
            response: error.response,
          );
        }
      case DioErrorType.receiveTimeout:
        {
          return AppException(
            code: -2,
            requestOptions: error.requestOptions,
            message: receiveTimeout,
            error: error.error,
            response: error.response,
          );
        }
      case DioErrorType.badResponse:
        {
          int errCode = error.response?.statusCode ?? -999;
          switch (errCode) {
            case 400:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: syntaxError,
                  error: error.error,
                  response: error.response,
                );
              }
            case 401:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: notAuthorized,
                  error: error.error,
                  response: error.response,
                );
              }
            case 403:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: serviceRefuse,
                  error: error.error,
                  response: error.response,
                );
              }
            case 404:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: notFoundService,
                  error: error.error,
                  response: error.response,
                );
              }
            case 405:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: requestForbidden,
                  error: error.error,
                  response: error.response,
                );
              }
            case 500:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: serverInternalError,
                  error: error.error,
                  response: error.response,
                );
              }
            case 502:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: requestInvalid,
                  error: error.error,
                  response: error.response,
                );
              }
            case 503:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: serverShutdown,
                  error: error.error,
                  response: error.response,
                );
              }
            case 505:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  message: unsupportedHTTPProtocol,
                  error: error.error,
                  response: error.response,
                );
              }
            default:
              {
                return AppException(
                  code: errCode,
                  requestOptions: error.requestOptions,
                  error: error.error,
                  message: error.response?.statusMessage ?? unknownError,
                  response: error.response,
                );
              }
          }
        }
      default:
        {
          return AppException(
            code: -1,
            requestOptions: error.requestOptions,
            error: error.error,
            response: error.response,
            message: error.message ?? error.error.toString(),
          );
        }
    }
  }

  @override
  String toString() {
    return '[$code]$message';
  }
}

/// 网络不可达
class UnreachableNetworkException extends AppException {
  UnreachableNetworkException(
      {super.code = -999,
      required super.requestOptions,
      super.message = '网络连接失败'});
}
