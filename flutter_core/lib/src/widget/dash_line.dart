import 'package:flutter/material.dart';

// 虚线
class DashLine extends StatelessWidget {
  const DashLine({
    Key? key,
    this.width = 2.0,
    this.height = 1.0,
    this.color,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final double width; // 虚线宽度
  final double height; // 虚线高度
  final Color? color; // 虚线颜色
  final Axis direction; // 虚线方向

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashCount = (boxWidth / (2 * width)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? width : height,
              height: direction == Axis.horizontal ? height : width,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: color ?? const Color(0xffE2E4EB)),
              ),
            );
          }),
        );
      },
    );
  }
}
