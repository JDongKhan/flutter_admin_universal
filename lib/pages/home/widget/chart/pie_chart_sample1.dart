import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../model/data.dart';

class PieChartSample1 extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  const PieChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: Chart(
        data: basicData,
        variables: {
          'genre': Variable(
            accessor: (Map map) => map['genre'] as String,
          ),
          'sold': Variable(
            accessor: (Map map) => map['sold'] as num,
          ),
        },
        transforms: [
          Proportion(
            variable: 'sold',
            as: 'percent',
          )
        ],
        elements: [
          IntervalElement(
            position: Varset('percent') / Varset('genre'),
            label: LabelAttr(
              encoder: (tuple) => Label(
                tuple['sold'].toString(),
                LabelStyle(style: Defaults.runeStyle),
              ),
            ),
            color: ColorAttr(
              variable: 'genre',
              values: Defaults.colors10,
              updaters: {
                'tap': {false: (color) => color.withAlpha(70)}
              },
            ),
            modifiers: [StackModifier()],
          )
        ],
        selections: {'tap': PointSelection(variable: 'genre')},
        coord: PolarCoord(transposed: true, dimCount: 1),
      ),
    );
  }
}
