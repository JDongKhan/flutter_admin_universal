///@Description TODO
///@Author jd

class TimeUtils {
  ///获取现在的时间
  static int getDayNow() {
    var nowTime = DateTime.now();
    return nowTime.millisecondsSinceEpoch;
  }

  ///获取今天的开始时间
  static int getDayBegin() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, nowTime.month, nowTime.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取昨天的开始时间
  static int getBeginDayOfYesterday() {
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(const Duration(days: -1));
    var day = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取昨天的结束时间
  static int getEndDayOfYesterday() {
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(const Duration(days: -1));
    var day =
        DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
    return day.millisecondsSinceEpoch;
  }

  ///获取本周的开始时间
  static int getBeginDayOfWeek() {
    var nowTime = DateTime.now();
    var weekday = nowTime.weekday;
    var yesterday = nowTime.add(Duration(days: -(weekday - 1)));
    var day = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取本月的开始时间
  static int getBeginDayOfMonth() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, nowTime.month, 1, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取本年的开始时间
  static int getBeginDayOfYear() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, 1, 1, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }
}
