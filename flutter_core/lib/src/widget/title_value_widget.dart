import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

class TitleValueWidget extends StatelessWidget {
  const TitleValueWidget({
    Key? key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.padding = const EdgeInsets.symmetric(
      vertical: 10,
    ),
    this.suffixWidget,
  }) : super(key: key);
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final EdgeInsets padding;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              title,
              style: titleStyle ??
                  const TextStyle(color: Color(0xff121E34), fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                value,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: valueStyle ??
                    const TextStyle(color: Color(0xff121E34), fontSize: 14),
              ),
            ),
          ),
          if (suffixWidget != null) suffixWidget!,
        ],
      ),
    );
  }
}
