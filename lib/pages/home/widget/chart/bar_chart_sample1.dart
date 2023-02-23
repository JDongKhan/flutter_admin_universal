import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../model/data.dart';

class BarChartSample1 extends StatelessWidget {
  const BarChartSample1({Key? key}) : super(key: key);

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
        elements: [
          IntervalElement(
            label:
                LabelAttr(encoder: (tuple) => Label(tuple['sold'].toString())),
            elevation: ElevationAttr(value: 0, updaters: {
              'tap': {true: (_) => 5}
            }),
            color: ColorAttr(value: Defaults.primaryColor, updaters: {
              'tap': {false: (color) => color.withAlpha(100)}
            }),
          )
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {'tap': PointSelection(dim: Dim.x)},
        tooltip: TooltipGuide(),
        crosshair: CrosshairGuide(),
      ),
    );
  }
}
