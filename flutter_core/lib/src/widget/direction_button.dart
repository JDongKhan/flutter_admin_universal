import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

///@author JD

///icon和text可以设定排版方向
class DirectionButton extends StatelessWidget {
  const DirectionButton({
    Key? key,
    this.action,
    this.icon,
    this.text,
    this.backgroundImage,
    this.width,
    this.height,
    this.middlePadding = 2.0,
    this.padding = const EdgeInsets.all(5),
    this.margin = const EdgeInsets.all(0),
    this.backgroundColor = Colors.transparent,
    this.imageDirection = AxisDirection.left,
  }) : super(key: key);

  final Icon? icon;
  final double middlePadding;
  final Function? action;
  final Text? text;
  final String? backgroundImage;
  final AxisDirection imageDirection;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget = icon;
    Widget? textWidget = text;

    double kpPadding = middlePadding;
    const double bPadding = 2;
    Widget? layoutWidget;
    List<Widget> childList = [];
    if (imageDirection == AxisDirection.up) {
      if (imageWidget != null) childList.add(imageWidget);
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: kpPadding,
            bottom: bPadding,
          ),
          child: textWidget,
        ));
      }
      layoutWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: childList,
      );
    } else if (imageDirection == AxisDirection.down) {
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: bPadding,
            bottom: kpPadding,
          ),
          child: textWidget,
        ));
      }
      if (imageWidget != null) childList.add(imageWidget);
      layoutWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: childList,
      );
    } else if (imageDirection == AxisDirection.left) {
      if (imageWidget != null) childList.add(imageWidget);
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: kpPadding,
            right: bPadding,
            top: 0,
            bottom: 0,
          ),
          child: textWidget,
        ));
      }

      layoutWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: childList,
      );
    } else if (imageDirection == AxisDirection.right) {
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: bPadding,
            right: kpPadding,
            top: 0,
            bottom: 0,
          ),
          child: textWidget,
        ));
      }
      if (imageWidget != null) childList.add(imageWidget);

      layoutWidget = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: childList,
      );
    }

    //背景颜色
    BoxDecoration? boxDecoration;
    if (backgroundImage != null) {
      boxDecoration = BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AssetBundleUtils.getImgPath(backgroundImage!)),
          fit: BoxFit.cover,
        ),
      );
    }

    layoutWidget = Container(
      width: width,
      height: height,
      color: backgroundColor,
      decoration: boxDecoration,
      padding: padding,
      margin: margin,
      child: layoutWidget,
    );
    if (action != null) {
      layoutWidget = GestureDetector(
        onTap: () {
          if (action != null) action?.call();
        },
        child: layoutWidget,
      );
    }

    return layoutWidget;
  }
}
