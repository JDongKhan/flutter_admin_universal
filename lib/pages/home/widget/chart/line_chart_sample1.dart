///@Description TODO
///@Author jd
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

const axisLabelStyle = TextStyle(color: Color(0xff75729e), fontSize: 10);

class _Line2Chart extends StatefulWidget {
  const _Line2Chart();

  @override
  State<_Line2Chart> createState() => _Line2ChartState();
}

class _Line2ChartState extends State<_Line2Chart> {
  final rdm = Random();
  List<Map> data = [];
  late Timer timer;
  @override
  void initState() {
    data = [
      {'genre': 'Sports', 'sold': rdm.nextInt(300)},
      {'genre': 'Strategy', 'sold': rdm.nextInt(300)},
      {'genre': 'Action', 'sold': rdm.nextInt(300)},
      {'genre': 'Shooter', 'sold': rdm.nextInt(300)},
      {'genre': 'Other', 'sold': rdm.nextInt(300)},
    ];

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (mounted) {
          data = [
            {'genre': 'Sports', 'sold': rdm.nextInt(300)},
            {'genre': 'Strategy', 'sold': rdm.nextInt(300)},
            {'genre': 'Action', 'sold': rdm.nextInt(300)},
            {'genre': 'Shooter', 'sold': rdm.nextInt(300)},
            {'genre': 'Other', 'sold': rdm.nextInt(300)},
          ];
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(5),
      child: ChartWidget(
        coordinateRender: ChartDimensionsCoordinateRender(
          margin: const EdgeInsets.only(left: 40, top: 5, right: 30, bottom: 30),
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
          crossHair: const CrossHairStyle(adjustHorizontal: true, adjustVertical: true),
          yAxis: [
            YAxis(min: 0, max: 500, drawGrid: true, count: 2),
            YAxis(min: 0, max: 400, count: 2, offset: (size) => Offset(size.width - 70, 0)),
          ],
          xAxis: XAxis(
            count: data.length - 1,
            max: data.length - 1,
            zoom: true,
            drawLine: false,
            formatter: (index) => data[index.toInt()]['genre'].toString(),
          ),
          charts: [
            Bar(
              color: Colors.yellow,
              data: data,
              yAxisPosition: 1,
              position: (item) => data.indexOf(item),
              value: (item) => item['sold'],
            ),
            Line(
              data: data,
              position: (item) => data.indexOf(item),
              values: (item) => [
                item['sold'] as num,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  _LineChart();
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
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: double.infinity,
      child: ChartWidget(
        coordinateRender: ChartDimensionsCoordinateRender(
          margin: const EdgeInsets.only(left: 40, top: 5, right: 0, bottom: 30),
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
            YAxis(min: 0, max: 500, drawGrid: true),
          ],
          xAxis: XAxis(
            count: 9,
            drawGrid: true,
            zoom: true,
            formatter: (index) => "$index",
          ),
          charts: [
            Line(
              data: dataList,
              //填充需要开启这个属性
              // filled: true,
              position: (item) => parserDateTimeToDayValue(item['time'] as DateTime, startTime),
              colors: [Colors.blue, Colors.red],
              dotColors: [Colors.blue, Colors.black],
              shaders: [
                ui.Gradient.linear(Offset.zero, const Offset(0, 200), [
                  Colors.red.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ]),
                ui.Gradient.linear(Offset.zero, const Offset(0, 200), [
                  Colors.blue.withOpacity(0.5),
                  Colors.yellow.withOpacity(0.5),
                ]),
              ],
              values: (item) => [
                item['value2'] as num,
                item['value1'] as num,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key, this.isShowingMainData = true}) : super(key: key);
  final bool isShowingMainData;

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 16.0, left: 6.0),
        child: widget.isShowingMainData ? _LineChart() : const _Line2Chart(),
      ),
    );
  }
}
