import 'dart:ui';

import 'package:flutter/material.dart';

/// Container(
//             width: 100,
//             height: 100,
//             decoration: DashDecoration(
//                 pointWidth: 2,
//                 step: 5,
//                 pointCount: 1,
//                 radius: const Radius.circular(15),
//                 gradient: const SweepGradient(colors: [
//                   Colors.blue,
//                   Colors.red,
//                   Colors.yellow,
//                   Colors.green
//                 ])),
//             child: const Icon(
//               Icons.add,
//               color: Colors.orangeAccent,
//               size: 40,
//             ),
//           ),
/// @author JD
class DashDecoration extends Decoration {
  const DashDecoration({
    this.gradient,
    required this.color,
    this.step = 2,
    this.strokeWidth = 1,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
    this.radius,
  });

  final Gradient? gradient;

  final Color color;
  final double step;
  final double span;
  final int pointCount;
  final double? pointWidth;
  final Radius? radius;
  final double strokeWidth;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      DashBoxPainter(this);
}

class DashBoxPainter extends BoxPainter {
  const DashBoxPainter(this._decoration);

  final DashDecoration _decoration;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) {
      return;
    }

    Radius radius = _decoration.radius ?? Radius.zero;
    canvas.save();
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.orangeAccent
      ..strokeWidth = _decoration.strokeWidth;
    final Path path = Path();

    canvas.translate(
      offset.dx + configuration.size!.width / 2,
      offset.dy + configuration.size!.height / 2,
    );

    final Rect zone = Rect.fromCenter(
      center: Offset.zero,
      width: configuration.size!.width,
      height: configuration.size!.height,
    );

    if (_decoration.color != null) {
      final Paint rectPaint = Paint()..color = _decoration.color;
      canvas.drawRRect(RRect.fromRectAndRadius(zone, radius), rectPaint);
    }

    path.addRRect(RRect.fromRectAndRadius(
      zone,
      radius,
    ));

    if (_decoration.gradient != null) {
      paint.shader = _decoration.gradient?.createShader(zone);
    }

    DashPainter(
      span: _decoration.span,
      step: _decoration.step,
      pointCount: _decoration.pointCount,
      pointWidth: _decoration.pointWidth,
    ).paint(canvas, path, paint);
    canvas.restore();
  }
}

class DashPainter {
  const DashPainter({
    this.step = 2,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
  });

  final double step;
  final double span;
  final int pointCount;
  final double? pointWidth;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    final double pointLineLength = pointWidth ?? paint.strokeWidth;
    final double partLength =
        step + span * (pointCount + 1) + pointCount * pointLineLength;

    pms.forEach((PathMetric pm) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        canvas.drawPath(
          pm.extractPath(partLength * i, partLength * i + step),
          paint,
        );
        for (int j = 1; j <= pointCount; j++) {
          final start =
              partLength * i + step + span * j + pointLineLength * (j - 1);
          canvas.drawPath(
            pm.extractPath(start, start + pointLineLength),
            paint,
          );
        }
      }
      final double tail = pm.length % partLength;
      canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
    });
  }
}
