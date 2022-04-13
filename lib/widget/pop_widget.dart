import 'package:flutter/material.dart';

/// @author jd

///弹框菜单， 朋友圈使用
void showPopMenu({
  required BuildContext context,

  ///context + alignment 组合使用
  required WidgetBuilder builder,
  Alignment alignment = Alignment.bottomLeft,
  Offset? offset,
  Axis axis = Axis.horizontal,

  ///left,top,right,bottom单独使用
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  Navigator.push(
    context,
    PopRoute(
      targetContext: context,
      alignment: alignment,
      builder: builder,
      offset: offset,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      axis: axis,
    ),
  );
}

class PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);

  PopRoute({
    required this.builder,

    ///targetContext + alignment 组合使用
    required this.targetContext,
    this.alignment = Alignment.bottomLeft,
    this.offset,

    ///left,top,right,bottom单独使用
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.axis = Axis.horizontal,
  });

  final WidgetBuilder builder;
  final double? left;

  ///距离左边位置
  final double? top;

  ///距离上面位置
  final double? right;

  ///距离上面位置
  final double? bottom;

  ///距离上面位置
  final Alignment alignment;
  final BuildContext targetContext;
  final Axis axis;

  ///是否等宽或等高
  final Offset? offset;

  ///偏移量

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double axisAlignment = 0;
    RenderBox box = targetContext.findRenderObject() as RenderBox;
    Rect frame = box.localToGlobal(Offset.zero) & box.size;
    // double screenWidth = MediaQuery.of(context).size.width;
    double? left = this.left;
    double? top = this.top;
    double? right = this.right;
    double? bottom = this.bottom;
    if (left == null && top == null && right == null && bottom == null) {
      if (alignment == Alignment.topLeft) {
        top = frame.top + (offset?.dy ?? 0);
        left = frame.left + (offset?.dx ?? 0);
        axisAlignment = 1;
      } else if (alignment == Alignment.topCenter) {
        top = frame.top + (offset?.dy ?? 0);
        left = frame.left + box.size.width / 2 + (offset?.dx ?? 0);
      } else if (alignment == Alignment.topRight) {
        top = frame.top + (offset?.dy ?? 0);
        left = frame.right + (offset?.dx ?? 0);
      } else if (alignment == Alignment.centerLeft) {
        top = frame.top + box.size.height / 2 + (offset?.dy ?? 0);
        left = frame.left + (offset?.dx ?? 0);
      } else if (alignment == Alignment.center) {
        top = frame.top + box.size.height / 2 + (offset?.dy ?? 0);
        left = frame.left + box.size.width / 2 + (offset?.dx ?? 0);
      } else if (alignment == Alignment.centerRight) {
        top = frame.top + box.size.height / 2 + (offset?.dy ?? 0);
        left = frame.right + (offset?.dx ?? 0);
      } else if (alignment == Alignment.bottomLeft) {
        top = frame.bottom + (offset?.dy ?? 0);
        left = frame.left + (offset?.dx ?? 0);
      } else if (alignment == Alignment.bottomCenter) {
        top = frame.bottom + (offset?.dy ?? 0);
        left = frame.left + box.size.width / 2 + (offset?.dx ?? 0);
      } else if (alignment == Alignment.bottomRight) {
        top = frame.bottom + (offset?.dy ?? 0);
        left = frame.right + (offset?.dx ?? 0);
      }
    }
    debugPrint('left:$left,right:$right,top:$top,bottom:$bottom');
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              child: FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: axisAlignment,
                  axis: axis,
                  child: builder(context),
                ),
              ),
              left: left,
              top: top,
              right: right,
              bottom: bottom,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => _duration;
}
