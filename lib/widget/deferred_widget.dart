import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();
typedef DeferredFutureBuilder = Future Function();

/// @author jd
class DeferredWidget extends StatefulWidget {
  const DeferredWidget({
    Key? key,
    required this.future,
    required this.builder,
    this.placeholder,
  }) : super(key: key);
  final Future future;
  final DeferredWidgetBuilder builder;
  final Widget? placeholder;
  @override
  State createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) return widget.builder();
        return widget.placeholder ??
            Container(
              color: Colors.transparent,
            );
      },
    );
  }
}
