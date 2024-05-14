import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';
import '../../model/data.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample2State();
}

class LineChartSample2State extends State {
  final DateTime startTime = DateTime(2023, 1, 1);

  @override
  Widget build(BuildContext context) {
    return _buildFirstChart();
  }

  Widget _buildFirstChart() {
    final List<Map> dataList = [
      {
        'time': startTime.add(const Duration(days: 1)),
        'value1': 100,
        'value2': 200,
        'value3': 300,
      },
      {
        'time': startTime.add(const Duration(days: 3)),
        'value1': 150,
        'value2': 250,
        'value3': 300,
      },
      {
        'time': startTime.add(const Duration(days: 5)),
        'value1': 200,
        'value2': 280,
        'value3': 300,
      },
      {
        'time': startTime.add(const Duration(days: 8)),
        'value1': 300,
        'value2': 450,
        'value3': 300,
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(30),
      height: 200,
      child: ChartWidget(
        coordinateRender: ChartDimensionsCoordinateRender(
          margin: const EdgeInsets.only(left: 40, top: 5, right: 30, bottom: 30),
          //提示的文案信息
          crossHair: const CrossHairStyle(adjustHorizontal: true, adjustVertical: true),
          tooltipBuilder: (BuildContext context, List<ChartLayoutParam> body) {
            return PreferredSize(
              preferredSize: const Size(60, 60),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(body.map((e) => e.selectedIndex).toString()),
              ),
            );
          },
          yAxis: [
            YAxis(
              min: 0,
              max: 500,
              drawGrid: true,
            ),
            YAxis(
              min: 0,
              max: 400,
              drawDivider: false,
              offset: (size) => Offset(size.width - 70, 0),
            ),
          ],
          xAxis: XAxis(
            count: 7,
            max: 20,
            drawGrid: true,
            drawLine: true,
            formatter: (index) => "$index",
          ),
          charts: [
            Bar(
              color: Colors.green,
              data: dataList,
              yAxisPosition: 1,
              position: (item) => parserDateTimeToDayValue(item['time'] as DateTime, startTime),
              value: (item) => item['value1'],
            ),
            Line(
              data: dataList,
              position: (item) => parserDateTimeToDayValue(item['time'] as DateTime, startTime),
              values: (item) => [
                item['value1'] as num,
              ],
            ),
            Line(
              colors: [Colors.green],
              data: dataList,
              position: (item) => parserDateTimeToDayValue(item['time'] as DateTime, startTime),
              values: (item) => [
                item['value2'] as num,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
