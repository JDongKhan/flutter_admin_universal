import 'package:flutter/material.dart';

///@Description TODO
///@Author jd
///局部设置
///TextButton(
//         onPressed: () {
//           onPressed?.call();
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: const Color(0xffEDEEF2),
//           splashFactory: NoSplashFactory(),
//         ),
//         child: child,
//       )
///  全局设置
///  ThemeData(
//         tabBarTheme: TabBarTheme.of(context)
//             .copyWith(labelStyle: TextStyle(fontFamily: 'FangZheng')),
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         fontFamily: "FangZheng", //全局默认字体
//         primaryColor: Colors.blueAccent,
//         highlightColor: Colors.transparent,
//         splashColor: Colors.transparent,
//         splashFactory: NoSplash.splashFactory,
//       ),
// 空水纹实现工厂
class NoSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create(
      {required MaterialInkController controller,
      required RenderBox referenceBox,
      required Offset position,
      required Color color,
      required TextDirection textDirection,
      bool containedInkWell = false,
      RectCallback? rectCallback,
      BorderRadius? borderRadius,
      ShapeBorder? customBorder,
      double? radius,
      VoidCallback? onRemoved}) {
    return _NoInteractiveInkFeature(
        controller: controller,
        referenceBox: referenceBox,
        color: color,
        onRemoved: onRemoved);
  }
}

// // InkFeature空实现
class _NoInteractiveInkFeature extends InteractiveInkFeature {
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
  _NoInteractiveInkFeature({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Color color,
    VoidCallback? onRemoved,
  }) : super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved);
}
