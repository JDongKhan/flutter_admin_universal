import 'package:flutter/material.dart';

/// @author jd

///base
class InfoCardStyleWidget extends StatelessWidget {
  const InfoCardStyleWidget({
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topTitleWidget(),
            _dataWidget(),
            Expanded(child: Container(child: _contentWidget())),
          ],
        ),
      ),
    );
  }

  //顶部title
  Widget _topTitleWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10,
                width: 2,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title ?? '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

  //数据
  Widget _dataWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        data ?? '',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  //内容
  Widget _contentWidget() {
    return content ?? Container();
  }
}

///style 1
class InfoCardStyle1Widget extends InfoCardStyleWidget {
  const InfoCardStyle1Widget({
    String? title,
    String? tip,
    String? data,
    this.bottomWidget,
  }) : super(title: title, tip: tip, data: data);

  final Widget? bottomWidget;
  @override
  Widget _contentWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ExpandButton(
                  title: Text(
                    '周同比 11%',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                ExpandButton(
                  order: InfoOrder.descending,
                  title: Text(
                    '日同比 12%',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          bottomWidget ??
              Text(
                '暂无',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
        ],
      ),
    );
  }
}

///style 2
class InfoCardStyle2Widget extends InfoCardStyleWidget {
  const InfoCardStyle2Widget({
    String? title,
    String? tip,
    String? data,
    this.chartWidget,
    this.bottomWidget,
  }) : super(title: title, tip: tip, data: data);

  final Widget? chartWidget;

  final Widget? bottomWidget;

  @override
  Widget _contentWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: chartWidget ?? _chartStyle1Widget()),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          bottomWidget ??
              Text(
                '暂无',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
        ],
      ),
    );
  }

  Widget _chartStyle1Widget() {
    return Container(
      child: Text('没有图表库'),
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
    this.iconSize = 12,
    this.iconColor,
    this.order = InfoOrder.ascending,
    required this.title,
  });

  final InfoOrder order;
  final Widget title;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        Icon(
          order == InfoOrder.ascending
              ? Icons.arrow_drop_up_outlined
              : Icons.arrow_drop_down_outlined,
          color: iconColor ??
              (order == InfoOrder.ascending ? Colors.red : Colors.green),
          size: iconSize,
        ),
      ],
    );
  }
}
