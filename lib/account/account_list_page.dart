import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

///@Description TODO
///@Author jd

// ignore: must_be_immutable
class AccountListPage extends StatefulWidget {
  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      enableRowChecked: true,
      readOnly: true,
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Role',
      field: 'role',
      type: PlutoColumnType.select(<String>[
        'Programmer',
        'Designer',
        'Owner',
      ]),
    ),
    PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ),
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
                rendererContext.stateManager.insertRows(
                  rendererContext.rowIdx,
                  [rendererContext.stateManager.getNewRow()],
                );
              },
              child: Text('添加'),
            ),
            TextButton(
              onPressed: () {
                rendererContext.stateManager.removeRows([rendererContext.row]);
              },
              child: Text('删除'),
            ),
          ],
        );
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
      PlutoColumnGroup(title: 'Etc.', fields: ['joined', 'working_time']),
    ]),
  ];

  List<PlutoRow>? rows;
  late final PlutoGridStateManager stateManager;

  @override
  void initState() {
    rows = List.generate(
      100,
      (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: 'user$index'),
          'name': PlutoCell(value: 'Mike'),
          'age': PlutoCell(value: 20),
          'role': PlutoCell(value: 'Programmer'),
          'joined': PlutoCell(value: '2021-01-01'),
          'working_time': PlutoCell(value: '09:00'),
          'op': PlutoCell(),
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: PlutoGrid(
          configuration: PlutoGridConfiguration(
            localeText: PlutoGridLocaleText.china(),
            enableColumnBorder: true,
            enableGridBorderShadow: true,
            gridBorderRadius: BorderRadius.circular(10),
            gridBorderColor: Color(0xFFDDE2EB),
          ),
          createFooter: (PlutoGridStateManager stateManager) {
            return PlutoPagination(stateManager);
          },
          // columnGroups: columnGroups,
          columns: columns,
          rows: rows!,
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            print(event);
          }),
    );
  }
}
