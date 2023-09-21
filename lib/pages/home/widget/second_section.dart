import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/sales_data.dart';
import 'chart/line_chart_sample1.dart';

/// @author jd

class SecondSection extends StatefulWidget {
  const SecondSection({Key? key}) : super(key: key);

  @override
  State<SecondSection> createState() => _SecondSectionState();
}

class _SecondSectionState extends State<SecondSection> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _dateSelectText;
  List<SalesData>? listData;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Card(
        color: Colors.white,
        child: SizedBox(
          height: 200,
          // margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              _topWidget(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 1,
                ),
              ),
              Expanded(child: _contentWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150,
          height: 30,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black87,
            labelStyle: const TextStyle(fontSize: 12),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.blue,
            tabs: const [
              Tab(
                child: Text(
                  '销售额',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'FangZheng',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '访问量',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'FangZheng',
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 1),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                    ),
                    child: const Text(
                      '今日',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 1),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                    ),
                    child: const Text(
                      '本周',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 1),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                    ),
                    child: const Text(
                      '本月',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 1),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                    ),
                    child: const Text(
                      '全年',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDateSelect();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withAlpha(100),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                      child: Row(
                        children: [
                          Text(
                            _dateSelectText ?? '2018-01-01 2018-12-31',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.date_range_outlined,
                            size: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDateSelect() async {
    DateTime start = DateTime.now();
    DateTime end = start.add(const Duration(days: 7));

    // showDialog<DateTimeRange>(
    //   context: context,
    //   useRootNavigator: true,
    //   useSafeArea: true,
    //   builder: (BuildContext context) {
    //     return GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).pop();
    //       },
    //       child: Container(
    //         color: Colors.black.withAlpha(5),
    //         child: Center(
    //           child: Container(
    //             color: Colors.white,
    //             width: 500,
    //             height: 300,
    //             child: SfDateRangePicker(
    //               initialSelectedDate: start,
    //               showActionButtons: true,
    //               onCancel: () {
    //                 Navigator.of(context).pop();
    //               },
    //               onSubmit: (obj) {
    //                 PickerDateRange range = obj as PickerDateRange;
    //
    //                 /// 此处时间需要格式化一下
    //                 String time = range.toString();
    //                 if (time != null && time.isNotEmpty) {
    //                   DateTime? startTime = range.startDate;
    //                   DateTime? endTime = range.endDate;
    //                   DateFormat format = DateFormat('yyyy-MM-dd');
    //                   _dateSelectText =
    //                       '${format.format(startTime!)} ${format.format(endTime!)}';
    //                   setState(() {});
    //                 }
    //                 Navigator.of(context).pop();
    //               },
    //               initialSelectedRange: PickerDateRange(start, end),
    //               onSelectionChanged: (DateRangePickerSelectionChangedArgs
    //                   dateRangePickerSelectionChangedArgs) {},
    //               selectionMode: DateRangePickerSelectionMode.range,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
    //
    DateTimeRange? selectTimeRange = await showDateRangePicker(
      context: context,
      locale: const Locale(
        'zh',
      ),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2021, 1),
      lastDate: DateTime(2022, 12),
      cancelText: '取消',
      confirmText: '确定',
      initialDateRange: DateTimeRange(start: start, end: end),
      builder: (BuildContext context, Widget? child) {
        return Dialog(
          child: SizedBox(width: 400, child: child),
        );
      },
    );

    /// 此处时间需要格式化一下
    String? time = selectTimeRange?.toString();
    if (time != null && time.isNotEmpty) {
      DateTime startTime = selectTimeRange!.start;
      DateTime endTime = selectTimeRange.end;
      DateFormat format = DateFormat('yyyy-MM-dd');
      _dateSelectText = '${format.format(startTime)} ${format.format(endTime)}';
      setState(() {});
    }
  }

  Widget _contentWidget() {
    return TabBarView(
      controller: _tabController,
      children: const [
        Center(child: LineChartSample1()),
        Center(child: LineChartSample1(isShowingMainData: false)),
      ],
    );
  }
}
