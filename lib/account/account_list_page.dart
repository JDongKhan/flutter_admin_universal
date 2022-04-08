import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/top/main_top_widget.dart';
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
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainTopWidget(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
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
                columnGroups: columnGroups,
                columns: columns,
                rows: rows!,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  print(event);
                }),
          ),
        ),
      ],
    );
  }
}
