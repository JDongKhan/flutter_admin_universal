import 'package:flutter/material.dart';

/// @author jd

///base
///

Widget buildTitleWidget({required String title, String? tip}) {
  return Container(
    height: 25,
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 10,
              width: 2,
              color: Colors.black87,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        tip != null
            ? Tooltip(
                message: tip!,
                child: const Icon(
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

class InfoCardStyleWidget extends StatelessWidget {
  const InfoCardStyleWidget({
    super.key,
    this.title,
    this.tip,
    this.data,
    this.content,
  });

  final String? title;
  final String? tip;
  final String? data;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleWidget(title: title ?? '', tip: tip),
            _dataWidget(),
            Expanded(child: Container(child: contentWidget())),
          ],
        ),
      ),
    );
  }

  //数据
  Widget _dataWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        data ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  //内容
  Widget contentWidget() {
    return content ?? Container();
  }
}

///style 1
class InfoCardStyle1Widget extends InfoCardStyleWidget {
  const InfoCardStyle1Widget({
    super.key,
    String? title,
    String? tip,
    String? data,
    this.bottomWidget,
  }) : super(title: title, tip: tip, data: data);

  final Widget? bottomWidget;
  @override
  Widget contentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              ExpandButton(
                title: '周同比 11%',
              ),
              ExpandButton(
                order: InfoOrder.descending,
                title: '日同比 12%',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 10,
        ),
        bottomWidget ??
            const Text(
              '暂无',
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
      ],
    );
  }
}

///style 2
class InfoCardStyle2Widget extends InfoCardStyleWidget {
  const InfoCardStyle2Widget({
    super.key,
    String? title,
    String? tip,
    String? data,
    this.chartWidget,
    this.bottomWidget,
  }) : super(title: title, tip: tip, data: data);

  final Widget? chartWidget;

  final Widget? bottomWidget;

  @override
  Widget contentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: chartWidget ?? _chartStyle1Widget()),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 10,
        ),
        bottomWidget ??
            const Text(
              '暂无',
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
      ],
    );
  }

  Widget _chartStyle1Widget() {
    return Row(
      children: const [
        ExpandButton(
          title: '周同比 11%',
        ),
        Expanded(
          child: ExpandButton(
            order: InfoOrder.descending,
            title: '日同比 12%',
          ),
        ),
      ],
    );
  }
}

enum InfoOrder {
  ascending,
  descending,
}

///组件
class ExpandButton extends StatelessWidget {
  const ExpandButton({
    Key? key,
    this.iconSize = 12,
    this.iconColor,
    this.order = InfoOrder.ascending,
    required this.title,
  }) : super(key: key);

  final InfoOrder order;
  final String title;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: const TextStyle(fontSize: 10),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                order == InfoOrder.ascending
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                color: iconColor ??
                    (order == InfoOrder.ascending ? Colors.red : Colors.green),
                size: iconSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
