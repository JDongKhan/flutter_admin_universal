import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import 'developer_menu_page.dart';
import '../logger/platform_logger_output.dart';

final FloatMenuController floatMenuController = FloatMenuController();

class FloatMenuController extends ChangeNotifier {
  FloatMenuController();

  bool _isShow = false;
  bool _isShowLogConsole = false;
  OverlayEntry? _overlayEntry;

  get isShow => _isShow;

  void show(BuildContext context) {
    if (_isShow == true) {
      return;
    }
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return const FloatMenuWidget();
      },
    );
    Overlay.of(context, rootOverlay: true)?.insert(_overlayEntry!);
    _isShow = true;
    notifyListeners();
  }

  void gotoLogConsole(BuildContext context) {
    if (_isShowLogConsole) {
      return;
    }
    _isShowLogConsole = true;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const DeveloperMenuPage()));
    _isShowLogConsole = false;
  }

  void dismiss() {
    _isShow = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShow = false;
    notifyListeners();
  }
}

class FloatMenuWidget extends StatefulWidget {
  const FloatMenuWidget({
    Key? key,
    this.width = 40,
    this.height = 40,
  }) : super(key: key);

  final double width;
  final double height;
  @override
  State createState() => _FloatMenuWidgetState();
}

double left = 0;
double top = 100;

class _FloatMenuWidgetState extends State<FloatMenuWidget> {
  int _animalDuration = 0;
  double _width = 0, _height = 0;
  @override
  void initState() {
    PlatformLoggerOutput.instance.openLogCollection = true;
    _width = widget.width;
    _height = widget.height;
    super.initState();
  }

  @override
  void dispose() {
    PlatformLoggerOutput.instance.openLogCollection = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _animalDuration),
      top: top,
      left: left,
      width: _width,
      height: _height,
      child: GestureDetector(
        onTap: () {
          floatMenuController.gotoLogConsole(context);
        },
        onDoubleTap: () {
          floatMenuController.dismiss();
        },
        onPanStart: (DragStartDetails details) {
          setState(() {
            _animalDuration = 1;
            _width = widget.width + 20;
            _height = widget.height + 20;
          });
        },
        onPanUpdate: (DragUpdateDetails detail) {
          left = left + detail.delta.dx;
          top = top + detail.delta.dy;
          left = max(0, left);
          top = max(0, top);
          left = min(getScreenWidth() - widget.width, left);
          top = min(getScreenHeight() - widget.height, top);
          setState(() {});
        },
        onPanEnd: (DragEndDetails details) {
          _handEnd();
        },
        onPanCancel: () {
          _handEnd();
        },
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handEnd() {
    _animalDuration = 300;
    _width = widget.width;
    _height = widget.height;
    if (left < getScreenWidth() / 2) {
      setState(() {
        left = 0;
      });
    } else {
      setState(() {
        left = getScreenWidth() - widget.width;
      });
    }
  }
}
