import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

import '../../model/data.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 200,
      child: ChartWidget(
        coordinateRender: ChartCircularCoordinateRender(
          margin: const EdgeInsets.only(left: 40, top: 10, right: 10, bottom: 10),
          charts: [
            Pie(
              data: basicData,
              position: (item) => (double.parse(item['sold'].toString())),
              holeRadius: 40,
              valueTextOffset: 20,
              guideLine: true,
              centerTextStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              valueFormatter: (item) => item['sold'].toString(),
              legendFormatter: (item) => item['genre'].toString(),
            ),
          ],
        ),
      ),
    );
  }
}
