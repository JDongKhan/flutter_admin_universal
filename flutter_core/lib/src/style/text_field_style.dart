import 'package:flutter/material.dart';

import 'color_style.dart';

///@author JD

/// 无边框
InputBorder noBorder() {
  return const OutlineInputBorder(borderSide: BorderSide.none);
}

/// 与分隔线一样风格的边框
InputBorder dividerBorder() {
  return UnderlineInputBorder(
    //选中时外边框颜色
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(
      color: ColorsStyle.divider,
    ),
  );
}
