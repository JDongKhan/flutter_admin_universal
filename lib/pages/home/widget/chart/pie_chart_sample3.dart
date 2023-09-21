import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

import '../../model/data.dart';

class PieChartSample3 extends StatelessWidget {
  const PieChartSample3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: ChartWidget(
        coordinateRender: ChartCircularCoordinateRender(
          margin: const EdgeInsets.all(12),
          charts: [
            Radar(
              max: 100,
              data: roseData,
              fillColors: colors10.map((e) => e.withOpacity(0.2)).toList(),
              legendFormatter: () => roseData.map((e) => e['name']).toList(),
              valueFormatter: (item) => [
                item['value'],
              ],
              values: (item) => [
                (double.parse(item['value'].toString())),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
