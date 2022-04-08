import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

class User {
  User(this.name, this.age, this.sex);

  final String name;
  final int age;
  final String sex;
}

class UserListPage extends StatefulWidget {
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> _data = [];

  @override
  void initState() {
    List.generate(100, (index) {
      _data.add(User('老孟$index', index % 50, index % 2 == 0 ? '男' : '女'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: PaginatedDataTable(
        columnSpacing: 1,
        header: Text('header'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
        columns: [
          DataColumn(label: Text('姓名')),
          DataColumn(label: Text('性别')),
          DataColumn(label: Text('年龄')),
        ],
        source: MyDataTableSource(_data),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this.data);

  final List<User> data;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data[index].name}')),
        DataCell(Text('${data[index].sex}')),
        DataCell(Text('${data[index].age}')),
      ],
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data.length;
  }
}
