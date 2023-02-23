import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../model/data.dart';

class BarChartSample2 extends StatelessWidget {
  const BarChartSample2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: Chart(
        data: intervalData,
        variables: {
          'id': Variable(
            accessor: (Map map) => map['id'] as String,
          ),
          'min': Variable(
            accessor: (Map map) => map['min'] as num,
            scale: LinearScale(min: 0, max: 160),
          ),
          'max': Variable(
            accessor: (Map map) => map['max'] as num,
            scale: LinearScale(min: 0, max: 160),
          ),
        },
        elements: [
          IntervalElement(
            position: Varset('id') * (Varset('min') + Varset('max')),
            shape: ShapeAttr(
                value: RectShape(borderRadius: BorderRadius.circular(2))),
          )
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
      ),
    );
  }
}
