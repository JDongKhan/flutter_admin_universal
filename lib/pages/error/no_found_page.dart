import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage(this.error, {Key? key}) : super(key: key);

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("页面找不到:${error?.toString()}"),
      ),
    );
  }
}
