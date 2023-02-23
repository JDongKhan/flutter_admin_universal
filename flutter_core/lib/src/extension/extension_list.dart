import 'dart:convert';

extension ExtensionList<E> on List<E> {
  /// Transform list to json
  /// 将list转化为json字符串
  String toJsonString() {
    return jsonEncode(this);
  }

  /// 将list转化为json字符串，换行
  String getJsonPretty() {
    return const JsonEncoder.withIndent('\t').convert(this);
  }

  /// Get total value of list of num (int/double)
  /// 获取num列表的总值(int/double)
  /// Example: [1,2,3,4] => 10
  num valueTotal() {
    num total = 0;
    if (isEmpty) return total;
    if (this[0] is num) {
      for (var v in this) {
        num vnum = v as num;
        total += vnum;
      }
      return total;
    }
    throw const FormatException('Can only accepting list of num (int/double)');
  }

  E? getAtIndex(int index) {
    if (index >= length) {
      return null;
    }
    return this[index];
  }
}
