import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/left_menu/left_menu_page.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

import 'model/sales_data.dart';
import 'widget/info_card_widget.dart';
import 'widget/info_list_card_widget.dart';
import 'widget/second_section.dart';

/// @author jd
class MainContentPage extends StatefulWidget {
  @override
  _MainContentPageState createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage> {
  ScrollController _scrollController = ScrollController();
  List<SalesData>? listData;
  @override
  void initState() {
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // controller: _scrollController,
      slivers: [
        _firstSection(),
        SecondSection(),
        _thirdSection(),
      ],
    );
  }

  Widget _firstSection() {
    List<Widget> children = [];
    children.add(InfoCardStyle1Widget(
      title: '总销售额',
      tip: '销售额',
      data: '￥726,689',
      bottomWidget: Text(
        '日销售额 ￥42,245',
        style: TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '访问量',
      tip: '访问量',
      data: '826,167',
      bottomWidget: Text(
        '日访问量 7,205',
        style: TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '支付笔数',
      tip: '支付笔数',
      data: '52,745',
      chartWidget: _chartStyle4Widget(),
      bottomWidget: Text(
        '转化率 60%',
        style: TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '运营活动效果',
      tip: '运营活动效果',
      data: '86%',
      chartWidget: Center(
        child: LinearProgressIndicator(
          value: 0.86,
          backgroundColor: Colors.grey.withAlpha(100),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
      bottomWidget: Text(
        '周同比 12%',
        style: TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    int column = UniversalDashboard.isMobile() ? 2 : 4;
    double leftMenu = UniversalDashboard.isMobile() ? 0 : kMenuWidth;
    double cellWidth = (MediaQuery.of(context).size.width - leftMenu) / column;
    double cellHeight = 150;
    double childAspectRatio = cellWidth / cellHeight;
    return SliverPadding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return children[index];
        }, childCount: children.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: column,
          childAspectRatio: childAspectRatio,
        ),
      ),
    );
  }

  Widget _thirdSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(
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
        ),
      ),
    );
  }

  Widget _chartStyle1Widget() {
    return Container(
      alignment: Alignment.center,
      child: Text('没有引入图表库'),
    );
  }

  Widget _chartStyle2Widget() {
    return Container(
      alignment: Alignment.center,
      child: Text('没有引入图表库'),
    );
  }

  Widget _chartStyle3Widget() {
    return Container(
      alignment: Alignment.center,
      child: Text('没有引入图表库'),
    );
  }

  Widget _chartStyle4Widget() {
    return Container(
      alignment: Alignment.center,
      child: Text('没有引入图表库'),
    );
  }
}
