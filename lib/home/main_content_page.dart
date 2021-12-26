import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'model/sales_data.dart';
import 'widget/info_card_widget.dart';
import 'widget/info_list_card_widget.dart';
import 'widget/main_top_widget.dart';
import 'widget/second_section.dart';

/// @author jd
class MainContentPage extends StatefulWidget {
  @override
  _MainContentPageState createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage> {
  ScrollController _scrollController = ScrollController();
  TooltipBehavior _tooltipBehaviorRenderer;

  List<SalesData> listData;

  @override
  void initState() {
    _tooltipBehaviorRenderer = TooltipBehavior(enable: true);
    listData = <SalesData>[
      SalesData('浙江', 35),
      SalesData('江苏', 28),
      SalesData('上海', 34),
      SalesData('北京', 32),
      SalesData('南京', 40),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 1000),
      child: Column(
        children: [
          MainTopWidget(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _firstSection(),
                  SecondSection(),
                  _thirdSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstSection() {
    List<Widget> children = [];
    children.add(Expanded(
      child: InfoCardStyle1Widget(
        title: '总销售额',
        tip: '销售额',
        data: '￥726,689',
        bottomWidget: Text(
          '日销售额 ￥42,245',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    ));
    children.add(Expanded(
      child: InfoCardStyle2Widget(
        title: '访问量',
        tip: '访问量',
        data: '826,167',
        bottomWidget: Text(
          '日访问量 7,205',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    ));
    children.add(Expanded(
      child: InfoCardStyle1Widget(
        title: '支付笔数',
        tip: '支付笔数',
        data: '52,745',
        bottomWidget: Text(
          '转化率 60%',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    ));
    children.add(Expanded(
      child: InfoCardStyle1Widget(
        title: '运营活动效果',
        tip: '运营活动效果',
        data: '86%',
        bottomWidget: Text(
          '周同比 12%',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    ));
    return Container(
      child: UniversalDashboard.isMobile()
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: children.sublist(0, 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: children.sublist(2, 4),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            ),
    );
  }

  Widget _thirdSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: InfoListCardWidget(
            title: '线上热门搜索',
            tip: '线上热门搜索',
            content: Container(
              height: 200,
              child: _chartStyle1Widget(),
            ),
          ),
        ),
        Expanded(
          child: InfoListCardWidget(
            title: '销售额类别占比',
            tip: '销售额类别占比',
            content: Container(
              height: 200,
              child: _chartStyle3Widget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartStyle1Widget() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      // title: ChartTitle(text: '热门搜索'),
      tooltipBehavior: _tooltipBehaviorRenderer,
      series: <LineSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          dataSource: listData,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (sales, _) => sales.sales,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _chartStyle2Widget() {
    return SfSparkLineChart(
      data: [1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3],
    );
  }

  Widget _chartStyle3Widget() {
    ChartTypeCircular type = ChartTypeCircular.pie;
    return SfCircularChart(
      title: ChartTitle(text: '中国各省人口统计'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: type == ChartTypeCircular.pie
          ? _getPieSeries()
          : type == ChartTypeCircular.doughnut
              ? _getDoughnutSeries()
              : _getRadialBarSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<RadialBarSeries<SalesData, String>> _getRadialBarSeries() {
    return <RadialBarSeries<SalesData, String>>[
      RadialBarSeries<SalesData, String>(
        dataSource: listData,
        xValueMapper: (SalesData data, _) => data.year,
        yValueMapper: (SalesData data, _) => data.sales,
        dataLabelMapper: (SalesData data, _) => data.year,
        // pointRadiusMapper: _getPointRadiusMapper,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside),
        maximumValue: 10000,
        innerRadius: '1%',
      )
    ];
  }

  List<DoughnutSeries<SalesData, String>> _getDoughnutSeries() {
    return <DoughnutSeries<SalesData, String>>[
      DoughnutSeries<SalesData, String>(
          explode: true,
          dataSource: listData,
          xValueMapper: (SalesData data, _) => data.year,
          yValueMapper: (SalesData data, _) => data.sales,
          dataLabelMapper: (SalesData data, _) => data.year,
          // startAngle: 100,
          // endAngle: 100,
          pointRadiusMapper: _getPointRadiusMapper,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  List<PieSeries<SalesData, String>> _getPieSeries() {
    return <PieSeries<SalesData, String>>[
      PieSeries<SalesData, String>(
          explode: true,
          dataSource: listData,
          xValueMapper: (SalesData data, _) => data.year,
          yValueMapper: (SalesData data, _) => data.sales,
          dataLabelMapper: (SalesData data, _) => data.year,
          // startAngle: 100,
          // endAngle: 100,
          pointRadiusMapper: _getPointRadiusMapper,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  String _getPointRadiusMapper(SalesData data, int index) {
    return '100%';
  }
}
