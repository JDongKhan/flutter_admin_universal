import '/widget/row_or_column.dart';
import 'package:flutter/material.dart';

import '../../../widget/row_or_single.dart';
import 'chart/bar_chart_sample1.dart';
import 'chart/bar_chart_sample2.dart';
import 'chart/pie_chart_sample1.dart';
import 'chart/pie_chart_sample3.dart';
import 'chart_info_card_widget.dart';
import 'chart/line_chart_sample2.dart';

class ThirdSection extends StatelessWidget {
  const ThirdSection({
    Key? key,
    this.anchorKey,
  }) : super(key: key);
  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: ChartInfoCardWidget(
                  key: anchorKey,
                  title: '线上热门搜索',
                  tip: '线上热门搜索',
                  content: const LineChartSample2(),
                ),
              ),
              Expanded(
                flex: 2,
                child: ChartInfoCardWidget(
                  title: '应用类别占比',
                  tip: '应用类别占比',
                  content: _chartStyle3Widget(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: ChartInfoCardWidget(
                  title: '应用种类',
                  tip: '应用种类',
                  content: RowOrSingle(
                    children: [
                      BarChartSample1(),
                      BarChartSample2(),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: ChartInfoCardWidget(
                  title: '销售额类别占比',
                  tip: '销售额类别占比',
                  content: PieChartSample3(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartStyle3Widget() {
    return Container(
      alignment: Alignment.center,
      child: const PieChartSample1(),
    );
  }
}
