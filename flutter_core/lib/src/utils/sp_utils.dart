import 'dart:convert';

import 'package:flutter_core/src/extension/extension_list.dart';
import 'package:flutter_core/src/extension/extension_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'object_utils.dart';

///@author JD
/// sp存储工具类，适合存储轻量级数据，不建议存储json长字符串
class SpUtils {
  SpUtils._();
  static SharedPreferences? _prefs;

  /// 初始化，必须要初始化
  static Future<SharedPreferences?> init() async {
    if (ObjectUtils.isNull(_prefs)) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  /// 判断是否存在key的数据
  static bool hasKey(String? key) {
    if (_prefs == null) {
      return false;
    }
    Set? keys = getKeys();
    return keys?.contains(key) ?? false;
  }

  /// put object.
  /// 存储object类型数据
  static Future<bool> putObject(String key, Object? value) async {
    if (_prefs == null) {
      return false;
      //return Future.value(false);
    }
    return _prefs!.setString(key, value == null ? "" : json.encode(value));
  }

  /// 获取sp中key的map数据
  static Map? getObject(String key) {
    if (_prefs == null) {
      return null;
    }
    String? data = _prefs!.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  /// put object list.
  /// 存储sp中key的list集合
  static Future<bool> putObjectList(String key, List<Object>? list) async {
    if (_prefs == null) {
      return false;
      //return Future.value(false);
    }
    List<String>? dataList = list?.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs!.setStringList(key, dataList ?? []);
  }

  /// get object list.
  /// 获取sp中key的list集合
  static List<Map>? getObjectList(String key) {
    if (_prefs == null) {
      return null;
    }
    List<String>? dataLis = _prefs!.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  /// get string.
  /// 获取sp中key的字符串
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.getString(key) ?? defValue;
  }

  /// put string.
  /// 存储sp中key的字符串
  static Future<bool> putString(String key, String value) async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.setString(key, value);
  }

  /// get bool.
  /// 获取sp中key的布尔值
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.getBool(key) ?? defValue;
  }

  /// put bool.
  /// 存储sp中key的布尔值
  static Future<bool> putBool(String key, bool value) async {
    if (_prefs == null) {
      return false;
      // return Future.value(false);
    }
    return _prefs!.setBool(key, value);
  }

  /// get int.
  /// 获取sp中key的int值
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.getInt(key) ?? defValue;
  }

  /// put int.
  /// 存储sp中key的int值
  static Future<bool> putInt(String key, int value) async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.setInt(key, value);
  }

  /// get double.
  /// 获取sp中key的double值
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.getDouble(key) ?? defValue;
  }

  /// put double.
  /// 存储sp中key的double值
  static Future<bool> putDouble(String key, double value) async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.setDouble(key, value);
  }

  /// get string list.
  /// 获取sp中key的list<String>值
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.getStringList(key) ?? defValue;
  }

  /// put string list.
  /// 存储sp中key的list<String>值
  static Future<bool> putStringList(String key, List<String> value) async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.setStringList(key, value);
  }

  /// 获取sp中key的map值
  static Map? getStringMap(String key) {
    if (_prefs == null) {
      return null;
    }
    String? jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      Map map = json.decode(jsonString);
      return map;
    }
    return null;
  }

  /// 存储sp中key的map值
  static Future<bool> putStringMap(String key, Map value) async {
    if (_prefs == null) {
      return false;
      // return Future.value(false);
    }
    String? jsonMapString = value.toJsonString();
    return _prefs!.setString(key, jsonMapString);
  }

  /// 存储sp中key的list值
  static Future<bool> putStringList2(String key, List value) async {
    if (_prefs == null) {
      return false;
    }
    var jsonMapString = value.toJsonString();
    return _prefs!.setString(key, jsonMapString);
  }

  /// get dynamic.
  /// 获取sp中key的dynamic值
  static dynamic getDynamic(String key, {Object? defValue}) {
    if (_prefs == null) {
      return defValue;
    }
    return _prefs!.get(key) ?? defValue;
  }

  /// get keys.
  /// 获取sp中所有的key
  static Set<String>? getKeys() {
    if (_prefs == null) {
      return null;
    }
    return _prefs!.getKeys();
  }

  /// remove.
  /// 移除sp中key的值
  static Future<bool> remove(String key) async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.remove(key);
  }

  /// clear.
  /// 清除sp
  static Future<bool> clear() async {
    if (_prefs == null) {
      return false;
    }
    return _prefs!.clear();
  }

  ///检查初始化
  static bool isInitialized() {
    return _prefs != null;
  }
}
