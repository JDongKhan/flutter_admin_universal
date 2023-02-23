import 'package:flutter/material.dart';

import 'info_card_widget.dart';

/// @author jd

class ChartInfoCardWidget extends StatelessWidget {
  const ChartInfoCardWidget({
    Key? key,
    required this.title,
    this.tip,
    this.content,
  }) : super(key: key);

  final String title;
  final String? tip;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleWidget(title: title ?? '', tip: tip),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
            ),
            Container(child: _contentWidget()),
          ],
        ),
      ),
    );
  }

  //内容
  Widget _contentWidget() {
    return content ?? const SizedBox.shrink();
  }
}
