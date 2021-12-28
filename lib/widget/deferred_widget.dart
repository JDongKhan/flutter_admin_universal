import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

/// @author jd
class DeferredWidget extends StatefulWidget {
  const DeferredWidget({
    Key? key,
    this.libraryLoader,
    this.libraryLoaderFuture,
    required this.createWidget,
    this.placeholder,
  }) : super(key: key);
  final Future? libraryLoaderFuture;
  final LibraryLoader? libraryLoader;
  final DeferredWidgetBuilder createWidget;
  final Widget? placeholder;
  // 存储已经加载过了的libraryLoader
  static final Set<LibraryLoader> _loadedModules = {};

  static Future<void>? preload(LibraryLoader loader) {
    if (_loadedModules.contains(loader)) {
      return Future.value(true);
    } else {
      _loadedModules.add(loader);
      return loader();
    }
  }

  @override
  _DeferredWidgetState createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  DeferredWidgetBuilder? _loadedChildBuilder;
  @override
  void initState() {
    if (widget.libraryLoaderFuture != null) {
      widget.libraryLoaderFuture!.then(
        (value) => _onLibraryLoaded(),
      );
    } else {
      DeferredWidget.preload(widget.libraryLoader!)?.then(
        (value) => _onLibraryLoaded(),
      );
    }
    super.initState();
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadedChildBuilder = widget.createWidget;
    });
  }

  @override
  void didUpdateWidget(covariant DeferredWidget oldWidget) {
    //目的是让其child也跟着变化

    _onLibraryLoaded();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedChildBuilder != null) {
      return _loadedChildBuilder!();
    }
    return widget.placeholder ??
        Container(
          color: Colors.transparent,
        );
  }
}
