import 'package:flutter/material.dart';

/// @author jd

class InfoListCardWidget extends StatelessWidget {
  const InfoListCardWidget({
    required this.title,
    this.tip,
    required this.content,
  });

  final String title;
  final String? tip;
  final Widget content;

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
            _topTitleWidget(),
            Divider(
              height: 1,
            ),
            Container(child: _contentWidget()),
          ],
        ),
      ),
    );
  }

  //顶部title
  Widget _topTitleWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          tip != null
              ? Tooltip(
                  message: tip!,
                  child: Icon(
                    Icons.report_gmailerrorred_outlined,
                    color: Colors.grey,
                    size: 10,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //内容
  Widget _contentWidget() {
    return content;
  }
}
