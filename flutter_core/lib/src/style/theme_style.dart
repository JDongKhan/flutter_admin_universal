import 'dart:math';

import 'package:flutter/material.dart';

/// @author jd

class ThemeStyle extends ChangeNotifier {
  Color navigationBackgroundColor = const Color(0xFFEEEEEE);
  Color navigationTextColor = const Color(0xFF666666);

  bool showPerformanceOverlay = false;
  bool checkerboardRasterCacheImages = false;
  bool checkerboardOffscreenLayers = false;
  bool debugPaintSizeEnabled = false;
  bool debugPaintPointersEnabled = false;
  bool debugPaintLayerBordersEnabled = false;
  bool debugRepaintRainbowEnabled = false;

  /// 当前主题颜色
  MaterialColor? _themeColor;

  void switchTheme(MaterialColor color) {
    _themeColor = color;
    navigationBackgroundColor = _themeColor!;
    notifyListeners();
  }

  void switchPerformanceOverlay(bool value) {
    showPerformanceOverlay = value;
    notifyListeners();
  }

  void switchCheckerboardRasterCacheImages(bool value) {
    checkerboardRasterCacheImages = value;
    notifyListeners();
  }

  void switchCheckerboardOffscreenLayers(bool value) {
    checkerboardOffscreenLayers = value;
    notifyListeners();
  }

  void switchDebugPaintSizeEnabled(bool value) {
    debugPaintSizeEnabled = value;
    notifyListeners();
  }

  void switchDebugPaintPointersEnabled(bool value) {
    debugPaintPointersEnabled = value;
    notifyListeners();
  }

  void switchDebugPaintLayerBordersEnabled(bool value) {
    debugPaintLayerBordersEnabled = value;
    notifyListeners();
  }

  void switchDebugRepaintRainbowEnabled(bool value) {
    debugRepaintRainbowEnabled = value;
    notifyListeners();
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme(Brightness brightness) {
    final int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(Colors.primaries[colorIndex]);
  }
}
