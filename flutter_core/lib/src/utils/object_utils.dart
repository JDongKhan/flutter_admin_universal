/// @author jd
///
/// Object Util.

/// Returns [true] if [s] is either null, empty or is solely made of whitespace
/// characters (as defined by [String.trim]).
bool isBlank(String? s) => s == null || s.trim().isEmpty;

/// Returns [true] if [s] is neither null, empty nor is solely made of whitespace
/// characters.
///
/// See also:
///
///  * [isBlank]
bool isNotBlank(String? s) => s != null && s.trim().isNotEmpty;

/// Returns [true] if [s] is either null or empty.
bool isEmpty(String? s) => s == null || s.isEmpty;

/// Returns [true] if [s] is a not empty string.
bool isNotEmpty(String? s) => s != null && s.isNotEmpty;

/// Returns [true] if [s] is either null or empty.
bool isArrayEmpty(List? s) => s == null || s.isEmpty;

/// Returns [true] if [s] is a not empty string.
bool isArrayNotEmpty(List? s) => s != null && s.isNotEmpty;

class ObjectUtils {
  /// 判断对象是否为null
  static bool isNull(dynamic s) => s == null;

  /// Returns true if the string is null or 0-length.
  static bool isEmptyString(String? str) {
    return str == null || str.isEmpty;
  }

  /// Returns true if the list is null or 0-length.
  static bool isEmptyList(List? list) {
    return list == null || list.isEmpty;
  }

  /// Returns true if there is no key/value pair in the map.
  static bool isEmptyMap(Map? map) {
    return map == null || map.isEmpty;
  }

  /// Returns true  String or List or Map is empty.
  static bool isEmpty(Object? object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  /// Returns true String or List or Map is not empty.
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  /// Returns true Two List Is Equal.
  static bool twoListIsEqual(List? listA, List? listB) {
    if (listA == listB) return true;
    if (listA == null || listB == null) return false;
    int length = listA.length;
    if (length != listB.length) return false;
    for (int i = 0; i < length; i++) {
      if (!listA.contains(listB[i])) {
        return false;
      }
    }
    return true;
  }

  /// get length.
  static int getLength(Object? value) {
    if (value == null) return 0;
    if (value is String) {
      return value.length;
    } else if (value is List) {
      return value.length;
    } else if (value is Map) {
      return value.length;
    } else {
      return 0;
    }
  }

  ///safe转换string
  static String safeParseString(Object? obj) {
    if (obj == null) {
      return '';
    }
    if (obj is String) {
      return obj;
    }
    return obj.toString();
  }

  ///safe转换int
  static int safeParseInt(Object? obj) {
    if (obj == null || obj == '') {
      return 0;
    }
    if (obj is int) {
      return obj;
    }

    var intObj = int.tryParse(obj.toString());
    return intObj ?? 0;
  }

  ///safe转换double
  static double safeParseDouble(Object? obj) {
    if (obj == null || obj == '') {
      return 0.0;
    }
    if (obj is double) {
      return obj;
    }
    var doubleObj = double.tryParse(obj.toString());
    return doubleObj ?? 0.0;
  }

  ///safe转换bool
  static bool safeParseBool(Object? obj) {
    if (obj == null || obj == '') {
      return false;
    }
    if (obj is int) {
      return obj > 0;
    }
    if (obj is String) {
      return obj == 'true';
    }
    if (obj is bool) {
      return obj;
    }
    return false;
  }

  ///safe转换Map
  static Map? safeParseMap(Object? obj) {
    if (obj is Map) {
      return obj;
    }
    return null;
  }
}
