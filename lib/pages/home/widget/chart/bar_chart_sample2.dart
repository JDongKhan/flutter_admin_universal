import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

import '../../model/data.dart';

class BarChartSample2 extends StatelessWidget {
  BarChartSample2({Key? key}) : super(key: key);

  final DateTime startTime = DateTime(2023, 1, 1);

  @override
  Widget build(BuildContext context) {
    final List<Map> dataList = [
      {
        'time': startTime.add(const Duration(days: 1)),
        'value1': 100,
        'value2': 200,
        'value3': 300,
      },
      {
        'time': startTime.add(const Duration(days: 3)),
        'value1': 200,
        'value2': 400,
        'value3': 300,
      },
      {
        'time': startTime.add(const Duration(days: 5)),
        'value1': 400,
        'value2': 200,
        'value3': 100,
      },
      {
        'time': startTime.add(const Duration(days: 8)),
        'value1': 100,
        'value2': 300,
        'value3': 200,
      },
    ];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: ChartWidget(
        coordinateRender: ChartDimensionsCoordinateRender(
          animationDuration: const Duration(seconds: 1),
          yAxis: [YAxis(min: 0, max: 500)],
          margin: const EdgeInsets.only(left: 40, top: 0, right: 0, bottom: 30),
          xAxis: XAxis(
            count: 4,
            max: 10,
            formatter: (index) {
              return '$index';
            },
          ),
          charts: [
            StackBar(
              data: dataList,
              position: (item) {
                return parserDateTimeToDayValue(item['time'] as DateTime, startTime);
              },
              direction: Axis.horizontal,
              itemWidth: 10,
              highlightColor: Colors.yellow,
              valuesFormatter: (item) => [item['value1'].toString(), item['value2'].toString(), item['value3'].toString()],
              values: (item) => [
                double.parse(item['value1'].toString()),
                double.parse(item['value2'].toString()),
                double.parse(item['value3'].toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
