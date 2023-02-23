import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class RowOrSingle extends StatelessWidget {
  const RowOrSingle({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.flexList,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);
  final List<Widget> children;
  final List<int>? flexList;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (ScreenUtils.isMobile()) {
      return children.first;
    }
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .map(
              (e) =>
                  Expanded(flex: flexList?[children.indexOf(e)] ?? 1, child: e),
            )
            .toList(),
      ),
    );
  }
}
