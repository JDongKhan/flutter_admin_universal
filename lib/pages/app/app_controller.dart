import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../http/app_service.dart';
import '../../http/model/release_info.dart';
import '../../platform/platform_adapter.dart';
import '../../utils/app_utils.dart';

class AppController {
  final List<PlutoRow> rows = [];
  final List<ReleaseInfo> data = [];
  late List<PlutoColumn> columns;

  void init() {
    columns = <PlutoColumn>[
      PlutoColumn(
        enableRowChecked: true,
        readOnly: true,
        title: 'Id',
        field: 'id',
        width: 150,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '名称',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '路径',
        width: 1000,
        field: 'path',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '类型',
        field: 'type',
        width: 100,
        type: PlutoColumnType.select(<String>[
          'iOS',
          'Android',
        ]),
      ),
      PlutoColumn(
        title: '上传时间',
        field: 'create_time',
        type: PlutoColumnType.date(format: 'yyyy-MM-dd HH:mm:ss'),
      ),
      // PlutoColumn(
      //   title: 'Working time',
      //   field: 'working_time',
      //   type: PlutoColumnType.time(),
      // ),
      PlutoColumn(
        title: '操作',
        field: 'op',
        readOnly: true,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableDropToResize: false,
        titleTextAlign: PlutoColumnTextAlign.center,
        enableSorting: false,
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _downloadAction(rendererContext);
                },
                child: const Text('下载'),
              ),
              TextButton(
                onPressed: () {
                  _deleteAction(rendererContext);
                },
                child: const Text('删除'),
              ),
            ],
          );
        },
      ),
    ];
  }

  //添加行
  void addRowAction(
      ReleaseInfo releaseInfo, PlutoGridStateManager stateManager) {
    data.add(releaseInfo);
    stateManager.appendRows([_buildRow(releaseInfo)]);
  }

  //下载文件
  void _downloadAction(PlutoColumnRendererContext rendererContext) {
    int row = rendererContext.rowIdx;
    String? url = data.getAtIndex(row)?.path;
    if (url == null) {
      return;
    }
    platformAdapter.downloadFile(url).then((value) {
      if (value != null) {
        debugPrint('开始安装:$value');
        AppUtils.installApp(value);
      }
    });
  }

  //删除
  void _deleteAction(PlutoColumnRendererContext rendererContext) {
    int row = rendererContext.rowIdx;
    int? id = data.getAtIndex(row)?.id;
    if (id == null) {
      return;
    }
    AppService.deleteById(id).then((value) {
      if (value) {
        int row = rendererContext.rowIdx;
        data.removeAt(row);
        rendererContext.stateManager.removeRows([rendererContext.row]);
      }
    });
  }

  //请求接口
  Future<List<PlutoRow>?> _fetchRows() async {
    List<ReleaseInfo>? dataList = await AppService.list();
    data.clear();
    if (dataList != null) {
      data.addAll(dataList);
      List<PlutoRow> list = dataList.map((e) => _buildRow(e)).toList();
      return list;
    }
    return null;
  }

  //构造行数据
  PlutoRow _buildRow(ReleaseInfo e) {
    return PlutoRow(
      cells: {
        'id': PlutoCell(value: e.id),
        'name': PlutoCell(value: e.name),
        'path': PlutoCell(value: e.path),
        'type': PlutoCell(value: e.flag == '0' ? 'Android' : 'iOS'),
        'create_time': PlutoCell(value: e.createTime),
        'op': PlutoCell(),
      },
    );
  }

  //分页加载请求
  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    if (request.page == 1) {
      data.clear();
    }
    List<PlutoRow>? list = await _fetchRows();
    return PlutoLazyPaginationResponse(
      totalPage: 1,
      rows: list ?? [],
    );
  }
}
