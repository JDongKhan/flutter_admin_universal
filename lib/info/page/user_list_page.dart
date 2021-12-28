import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/home/widget/main_top_widget.dart';
import 'package:flutter_admin_universal/info/model/employee.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../widget/info_table.dart';

/// @author jd

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Employee> employees = [];
  int _currentPage = 0;
  int _rowsPerPage = 10;

  EmployeeDataSource? _employeeDataSource;
  final DataPagerController _dataPagerController = DataPagerController();

  @override
  void initState() {
    employees = getEmployees();
    _employeeDataSource = EmployeeDataSource(employees);
    super.initState();
  }

  List<Employee> getEmployees() {
    return [
      Employee(
          id: 1001 + _currentPage * 1000,
          name: 'Jame',
          designation: 'Project Lead',
          salary: 20000),
      Employee(
          id: 1002 + _currentPage * 1000,
          name: 'Kathryn',
          designation: 'Manager',
          salary: 30000),
      Employee(
          id: 1003 + _currentPage * 1000,
          name: 'Lara',
          designation: 'Developer',
          salary: 15000),
      Employee(
          id: 1004 + _currentPage * 1000,
          name: 'Michael',
          designation: 'Designer',
          salary: 20000),
      Employee(
          id: 1005 + _currentPage * 1000,
          name: 'Martin',
          designation: 'Developer',
          salary: 20000),
      Employee(
          id: 1006 + _currentPage * 1000,
          name: 'Newberry',
          designation: 'Developer',
          salary: 20000),
      Employee(
          id: 1007 + _currentPage * 1000,
          name: 'Balnc',
          designation: 'Developer',
          salary: 20000),
      Employee(
          id: 1008 + _currentPage * 1000,
          name: 'Perry',
          designation: 'Developer',
          salary: 20000),
      Employee(
          id: 1009 + _currentPage * 1000,
          name: 'Gable',
          designation: 'Developer',
          salary: 20000),
      Employee(
          id: 1010 + _currentPage * 1000,
          name: 'Grimes',
          designation: 'Developer',
          salary: 20000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MainTopWidget(),
          _topMenu(),
          const Divider(
            height: 1,
          ),
          Expanded(
            child: InfoTabel(
                employeeDataSource: _employeeDataSource!,
                rowsPerPage: _rowsPerPage),
          ),
          SfDataPager(
              visibleItemsCount: 5,
              controller: _dataPagerController,
              pageCount: 100,
              delegate: DataPagerDelegate(),
              onPageNavigationEnd: (idx) {
                _currentPage = idx;
                employees = getEmployees();
                _employeeDataSource = EmployeeDataSource(employees);
                setState(() {});
              },
              onRowsPerPageChanged: (count) {
                setState(() {
                  _rowsPerPage = count!;
                });
              }),
        ],
      ),
    );
  }

  Widget _topMenu() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                ),
                onPressed: () {},
                child: Text('新增'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                ),
                onPressed: () {},
                child: Text('设置'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
