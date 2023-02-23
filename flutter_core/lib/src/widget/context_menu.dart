import 'package:flutter/material.dart';

enum Position {
  //位于目标上方，三角指示器在左边
  aboveLeft,
  //位于目标上方，三角指示器在右边
  aboveRight,
  //位于目标下方，三角指示器在左边
  belowLeft,
  //位于目标下方，三角指示器在右边
  belowRight,
  //位于目标左边，三角指示器在上边
  leftTop,
  //位于目标左边，三角指示器在下边
  leftBottom,
  //位于目标右边，三角指示器在上边
  rightTop,
  //位于目标右边，三角指示器在下边
  rightBottom,
}

/// @author jd
///弹框菜单， 朋友圈使用
void showContextMenu({
  required BuildContext context,

  ///context + position 组合使用
  required WidgetBuilder builder,
  Position position = Position.belowLeft,
  Offset? offset,
  bool hiddenArrow = false,
  Color backgroundColor = Colors.white,
  Color borderColor = const Color(0xffeeeeee),
}) {
  Navigator.push(
    context,
    PopRoute(
      targetContext: context,
      position: position,
      builder: builder,
      offset: offset,
      hiddenArrow: hiddenArrow,
      backgroundColor: backgroundColor,
    ),
  );
}

class PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);

  PopRoute({
    required this.builder,

    ///targetContext + position 组合使用
    required this.targetContext,
    this.position = Position.belowLeft,
    this.offset,
    this.hiddenArrow = false,
    this.arrowWidth = 10,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xffeeeeee),
  });

  final WidgetBuilder builder;

  ///位置
  final Position position;

  ///目标的context
  final BuildContext targetContext;

  ///背景颜色
  final Color backgroundColor;

  ///边框颜色
  final Color borderColor;

  ///偏移量
  final Offset? offset;

  ///是否隐藏三角
  final bool hiddenArrow;

  ///三角的大小
  final double arrowWidth;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    //child
    Widget child = builder(context);

    //三角
    Widget triangle = _TriangleUpWidget(
      height: arrowWidth,
      width: arrowWidth,
      color: backgroundColor,
      borderColor: borderColor,
      position: position,
    );

    BoxDecoration boxDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: borderColor),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(2.0, 3.0), //阴影xy轴偏移量
          blurRadius: 5.0, //阴影模糊程度
          spreadRadius: 1.0, //阴影扩散程度
        ),
      ],
    );
    double padding = arrowWidth - 1;
    double axisAlignment = 0;
    RenderBox box = targetContext.findRenderObject() as RenderBox;
    Rect frame = box.localToGlobal(Offset.zero) & box.size;
    // double screenWidth = MediaQuery.of(context).size.width;
    double? left;
    double? top;
    double? right;
    double? bottom;
    Axis axis = Axis.horizontal;
    Widget rootChild = child;
    if (position == Position.aboveLeft || position == Position.aboveRight) {
      top = frame.top + (offset?.dy ?? 0) - box.size.height;
      left = frame.left + (offset?.dx ?? 0);
      axisAlignment = 1;
      axis = Axis.vertical;
      rootChild = Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: padding),
            decoration: boxDecoration,
            child: child,
          ),
          Positioned(
            left: position == Position.aboveLeft ? 10 : null,
            right: position == Position.aboveRight ? 10 : null,
            bottom: 0,
            child: triangle,
          ),
        ],
      );
    } else if (position == Position.belowLeft ||
        position == Position.belowRight) {
      top = frame.bottom + (offset?.dy ?? 0);
      left = frame.left + (offset?.dx ?? 0);
      axis = Axis.vertical;
      rootChild = Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: padding),
            decoration: boxDecoration,
            child: child,
          ),
          Positioned(
            left: position == Position.belowLeft ? 10 : null,
            right: position == Position.belowRight ? 10 : null,
            child: triangle,
          ),
        ],
      );
    } else if (position == Position.leftTop ||
        position == Position.leftBottom) {
      top = frame.top + (offset?.dy ?? 0);
      left = frame.left + (offset?.dx ?? 0);
      axisAlignment = 1;
      rootChild = Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Container(
            margin: EdgeInsets.only(right: padding),
            decoration: boxDecoration,
            child: child,
          ),
          Positioned(
            right: 0,
            top: position == Position.leftTop ? 10 : null,
            bottom: position == Position.leftBottom ? 10 : null,
            child: triangle,
          ),
        ],
      );
    } else if (position == Position.rightTop ||
        position == Position.rightBottom) {
      top = frame.top + (offset?.dy ?? 0);
      left = frame.right + (offset?.dx ?? 0);
      rootChild = Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: padding),
            decoration: boxDecoration,
            child: child,
          ),
          Positioned(
            left: 0,
            top: position == Position.rightTop ? 10 : null,
            bottom: position == Position.rightBottom ? 10 : null,
            child: triangle,
          ),
        ],
      );
    }
    if (hiddenArrow) {
      rootChild = Container(
        decoration: boxDecoration,
        child: child,
      );
    }
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
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              child: FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: axisAlignment,
                  axis: axis,
                  child: rootChild,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => _duration;
}

class _TriangleUpPainter extends CustomPainter {
  late Paint _paint; //画笔
  late Path _path; //绘制路径
  double? angle; //角度
  Position position = Position.belowLeft;
  late Paint _borderPaint; //画笔

  _TriangleUpPainter(Color color, Color? borderColor, this.position) {
    _paint = Paint()
      ..strokeWidth = 1.0 //线宽
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    _borderPaint = Paint()
      ..strokeWidth = 1.0 //线宽
      ..color = borderColor ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseX = size.width;
    final baseY = size.height;
    //起点
    if (position == Position.belowLeft || position == Position.belowRight) {
      _path.moveTo(baseX, baseY);
      _path.lineTo(baseX * 0.5, 0);
      _path.lineTo(0, baseY);
    } else if (position == Position.aboveLeft ||
        position == Position.aboveRight) {
      _path.moveTo(0, 0);
      _path.lineTo(baseX * 0.5, baseY);
      _path.lineTo(baseX, 0);
    } else if (position == Position.leftTop ||
        position == Position.leftBottom) {
      _path.moveTo(0, 0);
      _path.lineTo(baseX * 0.5, baseY * 0.5);
      _path.lineTo(0, baseY);
    } else if (position == Position.rightTop ||
        position == Position.rightBottom) {
      _path.moveTo(baseX, 0);
      _path.lineTo(0, baseY * 0.5);
      _path.lineTo(baseX, baseY);
    }
    canvas.drawPath(_path, _paint);
    canvas.drawPath(_path, _borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _TriangleUpWidget extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final Color? borderColor;
  final Position position;

  _TriangleUpWidget({
    Key? key,
    this.height = 10,
    this.width = 10,
    this.color = Colors.white,
    this.borderColor,
    this.position = Position.belowLeft,
  }) : super(key: key);

  @override
  _TriangleState createState() => _TriangleState();
}

class _TriangleState extends State<_TriangleUpWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: CustomPaint(
        painter: _TriangleUpPainter(
            widget.color, widget.borderColor, widget.position),
      ),
    );
  }
}
