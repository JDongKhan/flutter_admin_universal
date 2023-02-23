import 'package:flutter/material.dart';

import '../utils/transform_utils.dart';

extension ExtensionString on String {
  /// Checks if string is num (int or double).
  bool isNum() => num.tryParse(this) != null;

  /// 为了解决系统排版时，中文 和 英文 交界处 换行的问题。向文本中加入一个 Zero-width space (\u{200B})
  String get joinZeroWidthSpace => Characters(this).join('\u{200B}');

  String appendString(String? string) {
    if (string == null) {
      return this;
    }
    return this + string;
  }

  /// Transform string to int type
  int toInt({bool nullOnError = false}) {
    int? i = int.tryParse(this);
    if (i != null) return i;
    if (nullOnError) return 0;
    return 0;
  }

  /// Transform string to double type
  double toDouble({bool nullOnError = false}) {
    double? d = double.tryParse(this);
    if (d != null) return d;
    if (nullOnError) return 0.0;
    return 0.0;
  }

  /// Transform string to num type
  num? toNum({bool nullOnError = false}) =>
      nullOnError ? num.tryParse(this) : num.parse(this);

  /// Transform String millisecondsSinceEpoch (DateTime) to DateTime
  DateTime? toDateTime() {
    int ms = toInt(nullOnError: true);
    if (ms != 0) {
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }
    return null;
  }

  /// Transform string value to binary
  /// Example: 15 => 1111
  String? toBinary({bool nullOnError = false}) {
    if (!isNum()) {
      if (nullOnError) return null;
      throw const FormatException("Only accepting integer value");
    }
    return TransformUtils.toBinary(int.parse(this));
  }

  ///计算文本大小
  Size getBoundingTextSize(
    TextStyle style, {
    BuildContext? context,
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的 机型：华为 mate 9
        locale: context != null ? Localizations.localeOf(context) : null,
        text: TextSpan(text: this, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
