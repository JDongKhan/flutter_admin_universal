import 'dart:async';

///@Description TODO
///@Author jd

class CommonUtils {
  static final Map<String, Timer> _funcDebounce = {};
  static final Map<String, Timer> _funcThrottle = {};

  /// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [milliseconds]: 要迟延的毫秒时间
  static Function? debounce(Function? func, [int milliseconds = 200]) {
    if (func == null) {
      return null;
    }
    // ignore: prefer_function_declarations_over_variables
    Function target = () {
      String key = func.hashCode.toString();
      Timer? timer = _funcDebounce[key];
      if (timer == null) {
        func.call();
        timer = Timer(Duration(milliseconds: milliseconds), () {
          Timer? t = _funcDebounce.remove(key);
          t?.cancel();
          t = null;
        });
        _funcDebounce[key] = timer;
      }
    };
    return target();
  }

  /// 函数节流
  ///329017575
  /// [func]: 要执行的方法
  static Function? throttle(Future Function()? func,
      [int milliseconds = 1000]) {
    if (func == null) {
      return null;
    }
    // ignore: prefer_function_declarations_over_variables
    Function target = () {
      String key = func.hashCode.toString();
      Timer? timer = _funcThrottle.remove(key);
      timer?.cancel();
      timer = null;
      timer = Timer(Duration(milliseconds: milliseconds), () {
        func.call();
        Timer? t = _funcThrottle.remove(key);
        t?.cancel();
        t = null;
      });
      _funcThrottle[key] = timer;
    };
    return target();
  }

  /// 大于999显示999+
  static String getShowCountFromString(String? countString) {
    int? count;
    if (countString != null) {
      count = int.tryParse(countString);
    }
    if (count == null) {
      return '0';
    }
    return getShowCountFromInt(count);
  }

  /// 大于999显示999+
  static String getShowCountFromInt(int count) {
    if (count > 999) {
      return '999+';
    }
    return '$count';
  }
}
