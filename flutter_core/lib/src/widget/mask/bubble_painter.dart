import 'dart:math' as math;

import 'package:flutter/material.dart';

/// @author jd

///绘制气泡背景
class BubblePainter extends CustomPainter {
  BubblePainter(BubbleBuilder builder) {
    mAngle = builder.mAngle;
    mArrowHeight = builder.mArrowHeight;
    mArrowWidth = builder.mArrowWidth;
    mArrowPosition = builder.mArrowPosition;
    bubbleColor = builder.bubbleColor;
    mArrowLocation = builder.mArrowLocation;
    bubbleType = builder.bubbleType;
    mArrowCenter = builder.arrowCenter;
  }

  late Rect mRect;
  Path mPath = Path();
  late Paint mPaint = Paint();
  late double mArrowWidth;
  late double mAngle;
  late double mArrowHeight;
  late double mArrowPosition;
  late ArrowLocation mArrowLocation;
  late BubbleType bubbleType;
  late bool mArrowCenter = true;
  late Color bubbleColor;

  @override
  void paint(Canvas canvas, Size size) {
    setUp(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  ///设置绘制路径
  void setUpPath(ArrowLocation mArrowLocation, Path path) {
    switch (mArrowLocation) {
      case ArrowLocation.left:
        setUpLeftPath(mRect, path);
        break;
      case ArrowLocation.right:
        setUpRightPath(mRect, path);
        break;
      case ArrowLocation.top:
        setUpTopPath(mRect, path);
        break;
      case ArrowLocation.bottom:
        setUpBottomPath(mRect, path);
        break;
    }
  }

  ///开始绘制设置
  void setUp(Canvas canvas, Size size) {
    switch (bubbleType) {
      case BubbleType.color:
        mPaint.color = bubbleColor;
        break;
      case BubbleType.bitmap:
        break;
    }
    mRect = Rect.fromLTRB(0, 0, size.width, size.height);
    setUpPath(mArrowLocation, mPath);
    canvas.drawPath(mPath, mPaint);
  }

  ///绘制左边三角形
  void setUpLeftPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.bottom - rect.top) / 2 - mArrowHeight / 2;
    }
    path.moveTo(rect.left + mArrowWidth, mArrowHeight + mArrowPosition);
    path.lineTo(rect.left + mArrowWidth, mArrowHeight + mArrowPosition);
    path.lineTo(rect.left, mArrowPosition + mArrowHeight / 2);
    path.lineTo(rect.left + mArrowWidth, mArrowPosition);
    path.lineTo(rect.left + mArrowWidth, rect.top + mAngle);

    path.addRRect(RRect.fromLTRBR(rect.left + mArrowHeight, rect.top,
        rect.right, rect.bottom, Radius.circular(mAngle)));

    path.close();
  }

  ///绘制顶部三角形
  void setUpTopPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.right - rect.left) / 2 - mArrowWidth / 2;
    }

    path.moveTo(
        rect.left + math.min(mArrowPosition, mAngle), rect.top + mArrowHeight);
    path.lineTo(rect.left + mArrowPosition, rect.top + mArrowHeight);
    path.lineTo(rect.left + mArrowWidth / 2 + mArrowPosition, rect.top);
    path.lineTo(
        rect.left + mArrowWidth + mArrowPosition, rect.top + mArrowHeight);

    path.addRRect(RRect.fromLTRBR(rect.left, rect.top + mArrowHeight,
        rect.right, rect.bottom, Radius.circular(mAngle)));

    path.close();
  }

  ///绘制右边三角形
  void setUpRightPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.bottom - rect.top) / 2 - mArrowWidth / 2;
    }

    path.moveTo(rect.right - mArrowWidth, mArrowPosition);

    path.lineTo(rect.right - mArrowWidth, mArrowPosition);
    path.lineTo(rect.right, mArrowPosition + mArrowHeight / 2);
    path.lineTo(rect.right - mArrowWidth, mArrowPosition + mArrowHeight);

    path.moveTo(rect.left + mAngle, rect.top);

    path.addRRect(RRect.fromLTRBR(rect.left, rect.top,
        rect.right - mArrowHeight, rect.bottom, Radius.circular(mAngle)));

    path.close();
  }

  ///绘制底部三角形
  void setUpBottomPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.right - rect.left) / 2 - mArrowWidth / 2;
    }
    path.moveTo(
        rect.left + mArrowWidth + mArrowPosition, rect.bottom - mArrowHeight);
    path.lineTo(
        rect.left + mArrowWidth + mArrowPosition, rect.bottom - mArrowHeight);
    path.lineTo(rect.left + mArrowPosition + mArrowWidth / 2, rect.bottom);
    path.lineTo(rect.left + mArrowPosition, rect.bottom - mArrowHeight);

    path.addRRect(RRect.fromLTRBR(rect.left, rect.top, rect.right,
        rect.bottom - mArrowHeight, Radius.circular(mAngle)));

    path.close();
  }
}

class BubbleBuilder {
  static const double defaultArrowWith = 15;
  static const double defaultArrowHeight = 15;
  static const double defaultAngle = 20;
  static const double defaultArrowPosition = 50;
  static const Color defaultBubbleColor = Colors.white;

  ///圆角
  double mAngle = defaultAngle;

  ///箭头宽度
  double mArrowWidth = defaultArrowWith;

  ///箭头高度
  double mArrowHeight = defaultArrowHeight;

  ///箭头位置
  double mArrowPosition = defaultArrowPosition;

  ///背景颜色
  Color bubbleColor = defaultBubbleColor;

  ///背景类型，颜色
  BubbleType bubbleType = BubbleType.color;

  ///箭头位置
  ArrowLocation mArrowLocation = ArrowLocation.bottom;

  ///箭头是否需要剧中
  bool arrowCenter = true;

  BubblePainter build() {
    return BubblePainter(this);
  }
}

enum ArrowLocation {
  left,
  right,
  top,
  bottom,
}

enum BubbleType { color, bitmap }
