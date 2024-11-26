import 'package:flutter_core/flutter_core.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err is AppException) {
      handler.next(err);
      return;
    }
    final AppException appException = AppException.create(err);
    handler.next(appException);
  }
}
