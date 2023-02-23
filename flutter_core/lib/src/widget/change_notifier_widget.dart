import 'package:flutter/material.dart';

typedef ChangeNotifierWidgetBuilder<T> = Widget Function(
    BuildContext context, T changeNotifier);

class ChangeNotifierWidget<T extends ChangeNotifier> extends StatefulWidget {
  const ChangeNotifierWidget({
    Key? key,
    required this.changeNotifier,
    required this.builder,
  }) : super(key: key);
  final T changeNotifier;
  final ChangeNotifierWidgetBuilder<T> builder;

  @override
  State<ChangeNotifierWidget> createState() => _ChangeNotifierWidgetState();
}

class _ChangeNotifierWidgetState extends State<ChangeNotifierWidget> {
  @override
  void initState() {
    widget.changeNotifier.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    widget.changeNotifier.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.changeNotifier);
  }
}
