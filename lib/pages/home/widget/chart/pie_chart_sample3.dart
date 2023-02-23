import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../model/data.dart';

class PieChartSample3 extends StatelessWidget {
  const PieChartSample3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: Chart(
        data: roseData,
        padding: (size) => const EdgeInsets.all(10),
        variables: {
          'name': Variable(
            accessor: (Map map) => map['name'] as String,
          ),
          'value': Variable(
            accessor: (Map map) => map['value'] as num,
            scale: LinearScale(min: 0, marginMax: 0.1),
          ),
        },
        elements: [
          IntervalElement(
            label:
                LabelAttr(encoder: (tuple) => Label(tuple['name'].toString())),
            shape: ShapeAttr(
                value: RectShape(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            )),
            color: ColorAttr(variable: 'name', values: Defaults.colors10),
            elevation: ElevationAttr(value: 5),
          )
        ],
        coord: PolarCoord(startRadius: 0.15),
      ),
    );
  }
}
