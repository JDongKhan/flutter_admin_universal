import 'dart:convert';

extension ExtensionMap on Map {
  /// Transform map to json
  /// 将map转化为json字符串
  String toJsonString() {
    return jsonEncode(this);
  }

  /// 将map转化为json字符串换行
  String getJsonPretty() {
    return const JsonEncoder.withIndent('\t').convert(this);
  }

  String getString(String key) {
    dynamic v = this[key];
    if (v == null) {
      return '';
    }
    if (v is String) {
      return v;
    }
    return v.toString();
  }

  int getInt(String key) {
    dynamic v = this[key];
    if (v == null || v == '') {
      return 0;
    }
    if (v is int) {
      return v;
    }

    var intObj = int.tryParse(v.toString());
    return intObj ?? 0;
  }

  double getDouble(String key) {
    dynamic v = this[key];
    if (v == null || v == '') {
      return 0.0;
    }
    if (v is double) {
      return v;
    }
    var doubleObj = double.tryParse(v.toString());
    return doubleObj ?? 0.0;
  }

  bool getBool(String key) {
    dynamic v = this[key];
    if (v == null || v == '') {
      return false;
    }
    if (v is int) {
      return v > 0;
    }
    if (v is String) {
      return v == 'true';
    }
    return v;
  }

  Object? getObject(String key) {
    Object? v = this[key];
    if (v == null || v == '') {
      return null;
    }
    return v;
  }
}
