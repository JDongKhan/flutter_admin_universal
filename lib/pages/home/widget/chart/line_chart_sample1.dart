///@Description TODO
///@Author jd
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../model/data.dart';

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
        data = [
          {'genre': 'Sports', 'sold': rdm.nextInt(300)},
          {'genre': 'Strategy', 'sold': rdm.nextInt(300)},
          {'genre': 'Action', 'sold': rdm.nextInt(300)},
          {'genre': 'Shooter', 'sold': rdm.nextInt(300)},
          {'genre': 'Other', 'sold': rdm.nextInt(300)},
        ];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(5),
      child: Chart(
        rebuild: false,
        data: data,
        variables: {
          'genre': Variable(
            accessor: (Map map) => map['genre'] as String,
          ),
          'sold': Variable(
            accessor: (Map map) => map['sold'] as num,
          ),
        },
        elements: [IntervalElement()],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'tap': PointSelection(
            on: {
              GestureType.hover,
              GestureType.tap,
            },
            dim: Dim.x,
          )
        },
        tooltip: TooltipGuide(
          backgroundColor: Colors.black,
          elevation: 5,
          textStyle: Defaults.textStyle,
          variables: ['genre', 'sold'],
        ),
        crosshair: CrosshairGuide(),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: double.infinity,
      child: Chart(
        data: invalidData,
        variables: {
          'Date': Variable(
            accessor: (Map map) => map['Date'] as String,
            scale: OrdinalScale(tickCount: 5),
          ),
          'Close': Variable(
            accessor: (Map map) => (map['Close'] ?? double.nan) as num,
          ),
        },
        elements: [
          AreaElement(
            shape: ShapeAttr(value: BasicAreaShape(smooth: true)),
            color: ColorAttr(value: Defaults.colors10.first.withAlpha(80)),
          ),
          LineElement(
            shape: ShapeAttr(value: BasicLineShape(smooth: true)),
            size: SizeAttr(value: 0.5),
          ),
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: Dim.x,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [false, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
        ),
        crosshair: CrosshairGuide(followPointer: [false, true]),
      ),
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key, this.isShowingMainData = true})
      : super(key: key);
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
        child:
            widget.isShowingMainData ? const _LineChart() : const _Line2Chart(),
      ),
    );
  }
}
