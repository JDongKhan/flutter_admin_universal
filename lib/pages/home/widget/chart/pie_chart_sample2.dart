import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

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
      child: ChartWidget(
        coordinateRender: ChartCircularCoordinateRender(
          margin: const EdgeInsets.only(left: 50, top: 10, right: 40, bottom: 10),
          charts: [
            Pie(
              data: basicData,
              position: (item) => (double.parse(item['sold'].toString())),
              holeRadius: 40,
              valueTextOffset: 20,
              showValue: true,
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
