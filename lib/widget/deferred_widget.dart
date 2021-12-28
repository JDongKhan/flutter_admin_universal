import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function(Key key);

/// @author jd
class DeferredWidget extends StatefulWidget {
  const DeferredWidget({
    Key? key,
    required this.libraryLoader,
    required this.createWidget,
    this.placeholder,
  }) : super(key: key);
  final LibraryLoader libraryLoader;
  final DeferredWidgetBuilder createWidget;
  final Widget? placeholder;
  // 存储libraryLoader 对应的future数据
  static final Map<LibraryLoader, Future<void>> _moduleLoaders = {};
  // 存储已经加载过了的libraryLoader
  static final Set<LibraryLoader> _loadedModules = {};

  static Future<void>? preload(LibraryLoader loader) {
    if (!_moduleLoaders.containsKey(loader)) {
      _moduleLoaders[loader] = loader().then(
        (value) => _loadedModules.add(loader),
      );
    }
    return _moduleLoaders[loader];
  }

  @override
  _DeferredWidgetState createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  Widget? _loadedChild;
  final GlobalKey<State> _childKey = GlobalKey();
  @override
  void initState() {
    if (DeferredWidget._loadedModules.contains(widget.libraryLoader)) {
      _onLibraryLoaded();
    } else {
      DeferredWidget.preload(widget.libraryLoader)?.then(
        (value) => _onLibraryLoaded(),
      );
    }
    super.initState();
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadedChild = widget.createWidget(_childKey);
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
    return _loadedChild ??
        widget.placeholder ??
        Container(
          color: Colors.transparent,
        );
  }
}
