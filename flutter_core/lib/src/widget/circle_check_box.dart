import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

/// @author jd

///圆形checkbox，自定义样式的checkbox
class CircleCheckBox extends StatelessWidget {
  const CircleCheckBox({
    Key? key,
    this.value = false,
    this.unCheckColor = Colors.grey,
    this.checkColor = Colors.blue,
    this.usedImage = true,
    this.tapSize = const Size(18, 18),
    this.iconSize = const Size(18, 18),
    this.middlePadding = 6,
    this.text,
    required this.onChanged,
  }) : super(key: key);
  final bool value;
  final Color unCheckColor;
  final Color checkColor;
  final bool usedImage;
  final Size tapSize;
  final Size iconSize;
  final double middlePadding;
  final Widget? text;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget iconWidget = Container(
      width: tapSize.width,
      height: tapSize.height,
      alignment: Alignment.centerLeft,
      // color: Colors.red,
      child: usedImage ? _buildImage() : _buildIcon(),
    );
    if (text != null) {
      child = Row(
        children: [
          iconWidget,
          SizedBox(width: middlePadding),
          text!,
        ],
      );
    } else {
      child = iconWidget;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onChanged(!value);
      },
      child: child,
    );
  }

  Widget _buildIcon() {
    return value
        ? Icon(
            Icons.check_circle,
            color: checkColor,
          )
        : Icon(
            Icons.radio_button_unchecked_outlined,
            color: unCheckColor,
          );
  }

  Widget _buildImage() {
    return value
        ? Image.asset(
            AssetBundleUtils.getImgPath('checked'),
            package: 'flutter_core',
            width: iconSize.width,
            height: iconSize.height,
          )
        : Image.asset(
            AssetBundleUtils.getImgPath('unchecked'),
            package: 'flutter_core',
            width: iconSize.width,
            height: iconSize.height,
          );
  }
}
