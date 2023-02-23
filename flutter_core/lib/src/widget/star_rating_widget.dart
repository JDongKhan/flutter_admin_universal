import 'package:flutter/material.dart';

/// @author jd

///五星 评价
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    Key? key,
    this.value = 0.0,
    this.maxValue = 5,
  }) : super(key: key);
  final double value;
  final int maxValue;
  @override
  Widget build(BuildContext context) {
    List<Widget> maxChildren = List.generate(
      maxValue,
      (index) => const Icon(
        Icons.star,
        size: 16,
        color: Colors.grey,
      ),
    );

    int v = value > maxValue ? maxValue : value.toInt();

    List<Widget> children = List.generate(
      v,
      (index) => const Icon(
        Icons.star,
        size: 16,
        color: Colors.yellow,
      ),
    );

    if (value % 1 != 0) {
      children.add(ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: value % 1,
          child: const Icon(
            Icons.star,
            size: 16,
            color: Colors.yellow,
          ),
        ),
      ));
    }

    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: maxChildren,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        )
      ],
    );
  }
}
