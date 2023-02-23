import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class PieChartSample2 extends StatelessWidget {
  PieChartSample2({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> basicData = [
    {'genre': 'Sports', 'sold': 275},
    {'genre': 'Strategy', 'sold': 115},
    {'genre': 'Action', 'sold': 120},
    {'genre': 'Shooter', 'sold': 350},
    {'genre': 'Other', 'sold': 150},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 350,
      height: 300,
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
            color: ColorAttr(variable: 'genre', values: Defaults.colors10),
            modifiers: [StackModifier()],
          )
        ],
        coord: PolarCoord(
          transposed: true,
          dimCount: 1,
          startRadius: 0.4,
        ),
        selections: {'tap': PointSelection()},
        tooltip: TooltipGuide(renderer: centralPieLabel),
      ),
    );
  }

  List<Figure> centralPieLabel(
    Size size,
    Offset anchor,
    Map<int, Tuple> selectedTuples,
  ) {
    final tuple = selectedTuples.values.last;

    final titleSpan = TextSpan(
      text: '${tuple['genre']}\n',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    );

    final valueSpan = TextSpan(
      text: tuple['sold'].toString(),
      style: const TextStyle(
        fontSize: 28,
        color: Colors.black87,
      ),
    );

    final painter = TextPainter(
      text: TextSpan(children: [titleSpan, valueSpan]),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    painter.layout();

    final paintPoint = getPaintPoint(
      const Offset(175, 150),
      painter.width,
      painter.height,
      Alignment.center,
    );

    return [TextFigure(painter, paintPoint)];
  }
}
