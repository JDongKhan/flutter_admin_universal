import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum MouseRegionType { idle, onHover, onEnter, onExit }

typedef MouseRegionWidgetBuilder = Widget Function(
    BuildContext context, MouseRegionType type);

class MouseRegionWidget extends StatefulWidget {
  const MouseRegionWidget({
    Key? key,
    required this.builder,
    this.cursor = MouseCursor.defer,
    this.opaque = true,
    this.hitTestBehavior,
  }) : super(key: key);
  final MouseRegionWidgetBuilder builder;
  final MouseCursor cursor;
  final bool opaque;
  final HitTestBehavior? hitTestBehavior;
  @override
  State<MouseRegionWidget> createState() => _MouseRegionWidgetState();
}

class _MouseRegionWidgetState extends State<MouseRegionWidget> {
  MouseRegionType _type = MouseRegionType.idle;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      opaque: widget.opaque,
      hitTestBehavior: widget.hitTestBehavior,
      onEnter: (PointerEnterEvent event) {
        _type = MouseRegionType.onEnter;
        setState(() {});
      },
      onExit: (PointerExitEvent event) {
        _type = MouseRegionType.onExit;
        setState(() {});
      },
      onHover: (PointerHoverEvent event) {
        _type = MouseRegionType.onHover;
        setState(() {});
      },
      child: widget.builder.call(context, _type),
    );
  }
}
