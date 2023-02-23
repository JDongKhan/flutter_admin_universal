import '/http/log_service.dart';
import '/http/model/log.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

///@Description TODO
///@Author jd

// ignore: must_be_immutable
class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final List<PlutoRow> _rows = [];
  late List<PlutoColumn> _columns;

  late final PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    _columns = <PlutoColumn>[
      PlutoColumn(
        title: '操作时间',
        field: 'time',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '消息',
        field: 'message',
        readOnly: true,
        enableSorting: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '方法',
        field: 'method',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '操作IP',
        field: 'operationIp',
        width: 100,
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '操作路径',
        field: 'operationUrl',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '操作地址',
        field: 'operationLocation',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
    ];
  }

  //请求接口
  Future<List<PlutoRow>?> _fetchRows() async {
    List<Log>? dataList = await LogService.list();
    if (dataList != null) {
      List<PlutoRow> list = dataList.map((e) => _buildRow(e)).toList();
      return list;
    }
    return null;
  }

  //构造行数据
  PlutoRow _buildRow(Log e) {
    return PlutoRow(
      cells: {
        'time': PlutoCell(value: e.time),
        'message': PlutoCell(value: e.message),
        'method': PlutoCell(value: e.method),
        'operationIp': PlutoCell(value: e.operationIp),
        'operationUrl': PlutoCell(value: e.operationUrl),
        'operationLocation': PlutoCell(value: e.operationLocation),
      },
    );
  }

  //分页加载请求
  Future<PlutoLazyPaginationResponse> _fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    List<PlutoRow>? list = await _fetchRows();
    return PlutoLazyPaginationResponse(
      totalPage: 1,
      rows: list ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: MediaQuery.removePadding(
        //适配手机端
        removeTop: true,
        context: context,
        child: PlutoGrid(
            configuration: PlutoGridConfiguration(
              style: PlutoGridStyleConfig(
                enableColumnBorderVertical: true,
                enableColumnBorderHorizontal: true,
                enableGridBorderShadow: true,
                gridBorderRadius: BorderRadius.circular(10),
                gridBorderColor: const Color(0xFFDDE2EB),
              ),
              localeText: const PlutoGridLocaleText.china(),
            ),
            createFooter: (stateManager) {
              return PlutoLazyPagination(
                // Determine the first page.
                // Default is 1.
                initialPage: 1,

                // First call the fetch function to determine whether to load the page.
                // Default is true.
                initialFetch: true,

                // Decide whether sorting will be handled by the server.
                // If false, handle sorting on the client side.
                // Default is true.
                fetchWithSorting: true,

                // Decide whether filtering is handled by the server.
                // If false, handle filtering on the client side.
                // Default is true.
                fetchWithFiltering: true,

                // Determines the page size to move to the previous and next page buttons.
                // Default value is null. In this case,
                // it moves as many as the number of page buttons visible on the screen.
                pageSizeToMove: null,
                fetch: _fetch,
                stateManager: stateManager,
              );
            },
            // columnGroups: columnGroups,
            columns: _columns,
            rows: _rows,
            onChanged: (PlutoGridOnChangedEvent event) {
              debugPrint(event.toString());
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager.setShowLoading(true);
              // stateManager.setShowColumnFilter(true);
              debugPrint(event.toString());
            }),
      ),
    );
  }
}
