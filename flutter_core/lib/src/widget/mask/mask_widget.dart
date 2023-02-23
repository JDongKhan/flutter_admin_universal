import 'package:flutter/material.dart';

/// @author jd

OverlayEntry? overlayEntry;

class MarkEntry {
  const MarkEntry({
    required this.widget,
    this.top,
    this.left,
  });

  final Widget widget;
  final double? top;
  final double? left;
}

class MarkWidget extends StatefulWidget {
  const MarkWidget({super.key, required this.entryList});
  final List<MarkEntry> entryList;
  @override
  State createState() => _MarkWidgetState();
}

class _MarkWidgetState extends State<MarkWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final MarkEntry entry = widget.entryList[currentIndex];
    return GestureDetector(
      onTap: () {
        if (currentIndex >= (widget.entryList.length - 1)) {
          overlayEntry?.remove();
          overlayEntry = null;
          return;
        }
        setState(() {
          currentIndex++;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(
          0.4,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: entry.left,
              top: entry.top,
              child: Material(
                color: Colors.transparent,
                child: entry.widget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
