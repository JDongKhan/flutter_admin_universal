import 'package:flutter/material.dart';

///@author JD
//缩放路由动画
class ScaleRouter<T> extends PageRouteBuilder<T> {
  ScaleRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
    RouteSettings? routeSettings,
  }) : super(
          settings: routeSettings,
          pageBuilder: (BuildContext context, Animation<dynamic> animation,
                  Animation<dynamic> secondaryAnimation) =>
              child,
          transitionDuration: Duration(milliseconds: durationMs),
          transitionsBuilder: (BuildContext context, Animation<double> a1,
                  Animation<double> a2, Widget child) =>
              ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: a1, curve: curve)),
            child: child,
          ),
        );

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//渐变透明路由动画
class FadeRouter<T> extends PageRouteBuilder<T> {
  FadeRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
    RouteSettings? routeSettings,
  }) : super(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<dynamic> animation,
                    Animation<dynamic> secondaryAnimation) =>
                child,
            transitionDuration: Duration(milliseconds: durationMs),
            transitionsBuilder: (BuildContext context, Animation<double> a1,
                    Animation<double> a2, Widget child) =>
                FadeTransition(
                  opacity: Tween<double>(begin: 0.1, end: 1.0)
                      .animate(CurvedAnimation(
                    parent: a1,
                    curve: curve,
                  )),
                  child: child,
                ));

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//旋转路由动画
class RotateRouter<T> extends PageRouteBuilder<T> {
  RotateRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
  }) : super(
            pageBuilder: (BuildContext context, Animation<dynamic> animation,
                    Animation<dynamic> secondaryAnimation) =>
                child,
            transitionDuration: Duration(milliseconds: durationMs),
            transitionsBuilder: (BuildContext context, Animation<double> a1,
                    Animation<double> a2, Widget child) =>
                RotationTransition(
                  turns: Tween<double>(begin: 0.1, end: 1.0)
                      .animate(CurvedAnimation(
                    parent: a1,
                    curve: curve,
                  )),
                  child: child,
                ));

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//右--->左
class Right2LeftRouter<T> extends PageRouteBuilder<T> {
  Right2LeftRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
  }) : super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (BuildContext ctx, Animation<dynamic> a1,
                    Animation<dynamic> a2) =>
                child,
            transitionsBuilder: (
              BuildContext ctx,
              Animation<double> a1,
              Animation<double> a2,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child,
                ));

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//左--->右
class Left2RightRouter<T> extends PageRouteBuilder<T> {
  Left2RightRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
    RouteSettings? routeSettings,
  })  : assert(true),
        super(
            settings: routeSettings,
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (BuildContext ctx, Animation<dynamic> a1,
                Animation<dynamic> a2) {
              return child;
            },
            transitionsBuilder: (
              BuildContext ctx,
              Animation<double> a1,
              Animation<double> a2,
              Widget child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//上--->下
class Top2BottomRouter<T> extends PageRouteBuilder<T> {
  Top2BottomRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
    RouteSettings? routeSettings,
  }) : super(
            settings: routeSettings,
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (BuildContext ctx, Animation<dynamic> a1,
                Animation<dynamic> a2) {
              return child;
            },
            transitionsBuilder: (
              BuildContext ctx,
              Animation<double> a1,
              Animation<double> a2,
              Widget child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, -1.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//下--->上
class Bottom2TopRouter<T> extends PageRouteBuilder<T> {
  Bottom2TopRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
  }) : super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (BuildContext ctx, Animation<dynamic> a1,
                    Animation<dynamic> a2) =>
                child,
            transitionsBuilder: (
              BuildContext ctx,
              Animation<double> a1,
              Animation<double> a2,
              Widget child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//缩放+透明+旋转路由动画
class ScaleFadeRotateRouter<T> extends PageRouteBuilder<T> {
  ScaleFadeRotateRouter({
    required this.child,
    this.durationMs = 1000,
    this.curve = Curves.fastOutSlowIn,
  }) : super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (BuildContext ctx, Animation<dynamic> a1,
                    Animation<dynamic> a2) =>
                child, //页面
            transitionsBuilder: (
              BuildContext ctx,
              Animation<double> a1,
              Animation<double> a2,
              Widget child,
            ) =>
                RotationTransition(
                  //旋转动画
                  turns: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                    parent: a1,
                    curve: curve,
                  )),
                  child: ScaleTransition(
                    //缩放动画
                    scale: Tween<double>(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(parent: a1, curve: curve)),
                    child: FadeTransition(
                      opacity: //透明度动画
                          Tween<double>(begin: 0.5, end: 1.0).animate(
                              CurvedAnimation(parent: a1, curve: curve)),
                      child: child,
                    ),
                  ),
                ));

  final Widget child;
  final int durationMs;
  final Curve curve;
}

//无动画
class NoAnimRouter<T> extends PageRouteBuilder<T> {
  NoAnimRouter({
    required Widget child,
    RouteSettings? routeSettings,
  }) : super(
          settings: routeSettings,
          opaque: false,
          pageBuilder: (BuildContext context, Animation<dynamic> animation,
                  Animation<dynamic> secondaryAnimation) =>
              child,
          transitionDuration: const Duration(milliseconds: 0),
          transitionsBuilder: (BuildContext context,
                  Animation<dynamic> animation,
                  Animation<dynamic> secondaryAnimation,
                  Widget child) =>
              child,
        );
}
