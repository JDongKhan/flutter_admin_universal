import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/employee.dart';

/// @author jd
class InfoTabel extends StatefulWidget {
  const InfoTabel({
    this.employeeDataSource,
    this.rowsPerPage,
  });

  final EmployeeDataSource employeeDataSource;
  final int rowsPerPage;
  @override
  State<InfoTabel> createState() => _InfoTabelState();
}

class _InfoTabelState extends State<InfoTabel> {
  final DataGridController _dataGridController = DataGridController();

  final Color _headerColor = Colors.blue.withAlpha(50);

  Map<String, double> _columnWidths = {
    'id': double.nan,
    'name': double.nan,
    'designation': double.nan,
    'salary': double.nan,
    'operation': 120
  };

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      columnWidthMode: ColumnWidthMode.fill,
      allowColumnsResizing: true,
      allowEditing: true,
      allowSorting: true,
      showSortNumbers: true,
      allowPullToRefresh: true,
      rowsPerPage: widget.rowsPerPage,
      controller: _dataGridController,
      headerRowHeight: 40,
      rowHeight: 50,
      frozenRowsCount: 0,
      frozenColumnsCount: 0,
      headerGridLinesVisibility: GridLinesVisibility.both,
      gridLinesVisibility: GridLinesVisibility.both,
      // selectionMode: SelectionMode.single,
      navigationMode: GridNavigationMode.cell,
      tableSummaryRows: [
        // GridTableSummaryRow(
        //     showSummaryInRow: true,
        //     title: 'Total Employee Count: {Count}',
        //     columns: [
        //       GridSummaryColumn(
        //         name: 'Count',
        //         columnName: 'name',
        //         summaryType: GridSummaryType.count,
        //       )
        //     ],
        //     position: GridTableSummaryRowPosition.top),
        GridTableSummaryRow(
            showSummaryInRow: false,
            columns: [
              GridSummaryColumn(
                name: 'Sum',
                columnName: 'salary',
                summaryType: GridSummaryType.sum,
              )
            ],
            position: GridTableSummaryRowPosition.bottom)
      ],
      onColumnResizeUpdate: (details) {
        setState(() {
          _columnWidths[details.column.columnName] = details.width;
        });
        return true;
      },
      columns: <GridColumn>[
        GridColumn(
          columnName: 'id',
          width: _columnWidths['id'],
          label: Container(
            color: _headerColor,
            alignment: Alignment.center,
            child: Text('ID'),
          ),
        ),
        GridColumn(
          columnName: 'name',
          width: _columnWidths['name'],
          label: Container(
            color: _headerColor,
            alignment: Alignment.center,
            child: Text('Name'),
          ),
        ),
        GridColumn(
          columnName: 'designation',
          width: _columnWidths['designation'],
          label: Container(
            color: _headerColor,
            alignment: Alignment.center,
            child: Text(
              'Designation',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'salary',
          width: _columnWidths['salary'],
          label: Container(
            color: _headerColor,
            alignment: Alignment.center,
            child: Text('Salary'),
          ),
        ),
        GridColumn(
          columnName: 'operation',
          width: _columnWidths['operation'],
          label: Container(
            color: _headerColor,
            alignment: Alignment.center,
            child: Text('Operation'),
          ),
        ),
      ],
      stackedHeaderRows: [
        StackedHeaderRow(
          cells: [
            StackedHeaderCell(
              columnNames: ['id', 'name', 'designation', 'salary'],
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text('人员信息'),
                ),
              ),
            ),
            StackedHeaderCell(
              columnNames: ['operation'],
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text('操作'),
                ),
              ),
            ),
          ],
        ),
      ],
      source: widget.employeeDataSource,
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Employee> employees) {
    _employees = employees
        .map(
          (e) => DataGridRow(
            cells: [
              DataGridCell(columnName: 'id', value: e.id),
              DataGridCell(columnName: 'name', value: e.name),
              DataGridCell(columnName: 'designation', value: e.designation),
              DataGridCell(columnName: 'salary', value: e.salary),
              DataGridCell(columnName: 'operation', value: e),
            ],
          ),
        )
        .toList();
  }
  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map(
      (e) {
        if (e.columnName == 'operation') {
          return Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('编辑'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('删除'),
                ),
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          child: Text(e.value.toString()),
        );
      },
    ).toList());
  }

  @override
  Widget buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      alignment: Alignment.center,
      child: Text(summaryValue),
    );
  }
}
