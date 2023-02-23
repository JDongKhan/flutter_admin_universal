import 'package:dio/dio.dart';

///@author JD
/// 自定义异常
class AppException implements Exception {
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

  AppException([
    this._code,
    this._message,
  ]);

  factory AppException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return BadRequestException(-1, cancel);
        }
        break;
      case DioErrorType.connectTimeout:
        {
          return BadRequestException(-1, connectTimeout);
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return BadRequestException(-1, sendTimeout);
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return BadRequestException(-2, receiveTimeout);
        }
        break;
      case DioErrorType.response:
        {
          try {
            int errCode = error.response?.statusCode ?? -999;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return BadRequestException(errCode, syntaxError);
                }
                break;
              case 401:
                {
                  return UnauthorisedException(errCode, notAuthorized);
                }
                break;
              case 403:
                {
                  return UnauthorisedException(errCode, serviceRefuse);
                }
                break;
              case 404:
                {
                  return UnauthorisedException(errCode, notFoundService);
                }
                break;
              case 405:
                {
                  return UnauthorisedException(errCode, requestForbidden);
                }
                break;
              case 500:
                {
                  return UnauthorisedException(errCode, serverInternalError);
                }
                break;
              case 502:
                {
                  return UnauthorisedException(errCode, requestInvalid);
                }
                break;
              case 503:
                {
                  return UnauthorisedException(errCode, serverShutdown);
                }
                break;
              case 505:
                {
                  return UnauthorisedException(
                      errCode, unsupportedHTTPProtocol);
                }
                break;
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return AppException(
                      errCode, error.response?.statusMessage ?? unknownError);
                }
            }
          } on Exception catch (_) {
            return AppException(-1, unknownError);
          }
        }
        break;
      default:
        {
          return AppException(-1, error.message);
        }
    }
  }

  final String? _message;
  final int? _code;

  @override
  String toString() {
    return '[$_code]$_message';
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException([int code = -1, String message = ''])
      : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException([int code = -1, String message = ''])
      : super(code, message);
}

/// 网络不可达
class UnreachableNetworkException extends AppException {
  UnreachableNetworkException() : super(-99, '网络连接失败');
}

class BadClientException extends AppException {
  BadClientException() : super(-999, '客户端逻辑出错');
}
