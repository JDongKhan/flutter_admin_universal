import '/http/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../service/environment.dart';
import '../../widget/common_widget.dart';
import '../../http/model/user.dart';

///@Description TODO
///@Author jd

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> _data = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _phoneConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  _loadList() {
    UserService.list().then((value) {
      if (value != null) {
        _data.addAll(value);
        if (mounted) {
          setState(() {});
        }
      }
    }).catchError((error) {
      ToastUtils.toastError(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          width: double.infinity,
          child: PaginatedDataTable(
            header: const Text('用户列表'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addUserInfoDialog();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
            columns: const [
              DataColumn(label: Text('姓名')),
              DataColumn(label: Text('账号')),
              DataColumn(label: Text('手机号')),
            ],
            source: MyDataTableSource(_data),
          ),
        ),
      ),
    );
  }

  void _addUserInfoDialog() {
    showDialog(
        context: context,
        builder: (c) {
          return Dialog(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 40,
                        color: Colors.lightGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '添加用户信息',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(c).pop();
                              },
                              child: const Icon(
                                Icons.close,
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildFormTextField("姓名", Icons.people_alt_outlined,
                          controller: _nameController, notEmpty: true),
                      buildFormTextField("账号", Icons.account_box_outlined,
                          controller: _accountController, notEmpty: true),
                      buildFormTextField("密码", Icons.password_outlined,
                          controller: _passwordController,
                          obscureText: true,
                          notEmpty: true),
                      buildFormTextField("确认密码", Icons.password_outlined,
                          controller: _passwordConfirmController,
                          obscureText: true,
                          notEmpty: true),
                      buildFormTextField("手机号", Icons.phone_android_outlined,
                          controller: _phoneConfirmController, notEmpty: true),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 40, right: 40, top: 40, bottom: 40),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _add,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                          ),
                          child: const Text('保存',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _add() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Network.post(environment.path.registerUrl, data: {
      "name": _nameController.text,
      "phone": _phoneConfirmController.text,
      "isAdmin": 1,
      "account": _accountController.text,
      "password": _accountController.text
    }).then((value) {
      _loadList();
    }).catchError((error) {
      ToastUtils.toastError(error);
    });
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
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].account)),
        DataCell(Text(data[index].phone)),
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
