import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../../style/constants.dart';
import 'info_card_widget.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({
    Key? key,
    this.data,
    this.anchorKey,
  }) : super(key: key);
  final Map? data;
  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(InfoCardStyle1Widget(
      title: '访问量',
      tip: '访问量',
      data: data?.getString('loginCount') ?? '--',
      bottomWidget: Text(
        '日访问量 ${data?.getString('loginCountOfToday') ?? '--'}',
        style: const TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '发布量',
      tip: '发布量',
      data: data?.getString('uploadReleaseCount') ?? '--',
      bottomWidget: Text(
        '日发布量 ${data?.getString('uploadReleaseCountOfToday') ?? '--'}',
        style: const TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '查询量',
      tip: '查询量',
      data: data?.getString('queryReleaseCount') ?? '--',
      bottomWidget: Text(
        '日查询量 ${data?.getString('queryReleaseCountOfToday') ?? '--'}',
        style: const TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    children.add(InfoCardStyle2Widget(
      title: '运营活动效果',
      tip: '运营活动效果',
      data: '86%',
      key: anchorKey,
      chartWidget: Center(
        child: LinearProgressIndicator(
          value: 0.86,
          backgroundColor: Colors.grey.withAlpha(100),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
      bottomWidget: const Text(
        '周同比 12%',
        style: TextStyle(color: Colors.black45, fontSize: 12),
      ),
    ));
    int column = ScreenUtils.isMobile() ? 2 : 4;
    double leftMenu = ScreenUtils.isMobile() ? 0 : kMenuWidth;
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
}
