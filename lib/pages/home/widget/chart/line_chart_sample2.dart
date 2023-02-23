import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../../../widget/row_or_single.dart';
import '../../model/data.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample2State();
}

class LineChartSample2State extends State {
  final priceVolumeChannel = StreamController<GestureSignal>.broadcast();

  @override
  Widget build(BuildContext context) {
    return _buildFirstChart();
  }

  Widget _buildFirstChart() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(30),
      height: 200,
      child: Chart(
        padding: (_) => const EdgeInsets.fromLTRB(0, 5, 10, 0),
        rebuild: false,
        data: priceVolumeData,
        variables: {
          'time': Variable(
            accessor: (Map map) => map['time'] as String,
            scale: OrdinalScale(tickCount: 3),
          ),
          'end': Variable(
            accessor: (Map map) => map['end'] as num,
            scale: LinearScale(min: 5, tickCount: 5),
          ),
        },
        elements: [
          LineElement(
            size: SizeAttr(value: 1),
          )
        ],
        axes: [
          Defaults.horizontalAxis
            ..label = null
            ..line = null,
          Defaults.verticalAxis
            ..gridMapper =
                (_, index, __) => index == 0 ? null : Defaults.strokeStyle,
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
        crosshair: CrosshairGuide(
          followPointer: [true, false],
          styles: [
            StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
            StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
          ],
        ),
        gestureChannel: priceVolumeChannel,
      ),
    );
  }

  Widget _buildSecondChart() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 200,
      child: Chart(
        padding: (_) => const EdgeInsets.fromLTRB(40, 0, 10, 20),
        rebuild: false,
        data: priceVolumeData,
        variables: {
          'time': Variable(
            accessor: (Map map) => map['time'] as String,
            scale: OrdinalScale(tickCount: 3),
          ),
          'volume': Variable(
            accessor: (Map map) => map['volume'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        elements: [
          IntervalElement(
            size: SizeAttr(value: 1),
          )
        ],
        axes: [
          Defaults.horizontalAxis,
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
        crosshair: CrosshairGuide(
          followPointer: [true, false],
          styles: [
            StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
            StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
          ],
        ),
        gestureChannel: priceVolumeChannel,
      ),
    );
  }
}
