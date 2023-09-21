import 'package:flutter/material.dart';

class WebViewProgressController extends ChangeNotifier {
  double progress = 0.0;
  bool _show = false;

  void updateProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  void show() {
    _show = true;
    notifyListeners();
  }

  void dismiss() {
    _show = false;
    notifyListeners();
  }
}

class WebViewProgress extends StatefulWidget {
  final WebViewProgressController? controller;
  const WebViewProgress({super.key, this.controller});
  @override
  State createState() => _WebViewProgressState();
}

class _WebViewProgressState extends State<WebViewProgress> {
  @override
  void initState() {
    widget.controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.controller?._show ?? false,
      child: LinearProgressIndicator(
        // value: widget.account.progress,
        backgroundColor: Colors.grey[100],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
      ),
    );
  }
}
