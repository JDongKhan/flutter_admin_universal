import '/http/log_service.dart';
import '/widget/row_or_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../style/constants.dart';
import '../../widget/universal_dashboard.dart';
import 'model/sales_data.dart';
import 'widget/chart/pie_chart_sample1.dart';
import 'widget/first_section.dart';
import 'widget/forth_section.dart';
import 'widget/info_card_widget.dart';
import 'widget/chart_info_card_widget.dart';
import 'widget/chart/line_chart_sample2.dart';
import 'widget/second_section.dart';
import 'widget/third_section.dart';

/// @author jd
class MainContentPage extends StatefulWidget {
  const MainContentPage({super.key});

  @override
  State createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  List<SalesData>? listData;
  final GlobalKey _topWidgetKey = GlobalKey();
  final GlobalKey _centerWidgetKey = GlobalKey();
  @override
  void initState() {
    listData = <SalesData>[
      SalesData('浙江', 35),
      SalesData('江苏', 28),
      SalesData('上海', 34),
      SalesData('北京', 32),
      SalesData('南京', 40),
    ];

    // 页面展示时进行prompt绘制，在此添加observer监听等待渲染完成后挂载prompt
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!SpUtils.getBool('kShowPrompt')) {
        List<PromptItem> prompts = [];
        prompts.add(PromptItem(_topWidgetKey, "这是线上热门搜索"));
        prompts.add(PromptItem(_centerWidgetKey, "这是运营活动效果"));
        PromptBuilder.promptToWidgets(prompts);
        SpUtils.putBool('kShowPrompt', true);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        FutureBuilder(
          future: LogService.statisticsUrl(),
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              FirstSection(
            data: snapshot.data,
            anchorKey: _centerWidgetKey,
          ),
        ),
        _buildSelfAdaptionWidget(),
      ],
    );
  }

  Widget _buildSelfAdaptionWidget() {
    List<Widget> children = [];
    children.add(Column(
      children: [
        const SecondSection(),
        ThirdSection(
          anchorKey: _topWidgetKey,
        ),
      ],
    ));
    children.add(const ForthSection());
    return SliverToBoxAdapter(
        child: RowOrColumn(
      flexList: [3, 1],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ));
  }
}
