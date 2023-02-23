import 'dart:math';
import 'package:flutter/material.dart';

/// @author jd

//可拖动滚动条，直播模块使用
class DragProgressBar extends StatefulWidget {
  const DragProgressBar({
    Key? key,
    this.value = 0,
    this.inactiveColor = Colors.grey,
    this.activeColor = Colors.white,
    this.height = 3,
    this.onChanged,
    this.onPanStart,
    this.onPanEnd,
    this.onPanChanged,
  })  : assert(
          value >= 0,
        ),
        super(key: key);
  final double value;
  final double height;
  final Color inactiveColor;
  final Color activeColor;
  final ValueChanged<double>? onChanged;
  final VoidCallback? onPanStart;
  final VoidCallback? onPanEnd;
  final ValueChanged<double>? onPanChanged;

  @override
  State createState() => _DragProgressBarState();
}

class _DragProgressBarState extends State<DragProgressBar> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    double v = _value > 0 ? _value : widget.value;
    v = min(1, v);
    v = max(0, v);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.height),
            ),
            color: widget.inactiveColor,
          ),
        ),
        FractionallySizedBox(
          widthFactor: v,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.height),
                  ),
                  color: widget.activeColor,
                ),
                height: widget.height,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    if (widget.onPanStart != null) {
                      widget.onPanStart?.call();
                    }
                    _value = widget.value;
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    double p = details.delta.dx / context.size!.width;
                    double temp = _value + p;
                    temp = max(0, temp);
                    temp = min(1, temp);
                    _value = temp;
                    setState(() {});
                    if (widget.onPanChanged != null) {
                      widget.onPanChanged?.call(_value);
                    }
                  },
                  onPanEnd: (details) {
                    _value = 0;
                    if (widget.onPanEnd != null) {
                      widget.onPanEnd?.call();
                    }
                  },
                  onPanCancel: () {
                    _value = 0;
                    if (widget.onPanEnd != null) {
                      widget.onPanEnd?.call();
                    }
                  },
                  child: const Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
