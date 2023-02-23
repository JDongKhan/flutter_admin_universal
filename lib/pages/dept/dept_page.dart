import 'dart:math';

import '/widget/tree_widget/flutter_tree_widget.dart';
import 'package:flutter/material.dart';

class DeptPage extends StatefulWidget {
  const DeptPage({Key? key}) : super(key: key);

  @override
  State<DeptPage> createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  final GlobalKey _key = GlobalKey();
  var _loading = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 400,
          height: double.infinity,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white),
          child: FutureBuilder(
            future: _loadData(),
            builder: (c, c1) {
              if (c1.data == null) {
                return Container();
              }
              return TreeWidget(
                data: c1.data!,
                lazy: true,
                showFilter: false,
                showCheckBox: true,
                showActions: true,
                load: _loadMore,
                append: (parent) {
                  return TreeNode(
                    title: '默认名称',
                    expanded: true,
                    editable: true,
                    checked: true,
                    children: [],
                  );
                },
                onTap: (node) {
                  debugPrint("onTap");
                  setState(() {});
                },
                onCheck: (checked, node) {
                  debugPrint("onCheck");
                },
                onCollapse: (node) {
                  debugPrint("onCollapse");
                },
                onExpand: (node) {
                  debugPrint("onExpand");
                },
                onAppend: (node, parent) {
                  debugPrint("onAppend");
                },
                onRemove: (node, parent) {
                  debugPrint("onRemove");
                },
                onLoad: (node) {
                  debugPrint('onLoad');
                },
              );
            },
          ),
        ),
        Expanded(
            child: FutureBuilder(
          future: _loadUserList(),
          initialData: null,
          key: _key,
          builder: (c, c1) {
            if (c1.data == null || _loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildUserListWidget(c1.data);
          },
        )),
      ],
    );
  }

  //加载数据
  Future<List<TreeNode>> _loadData() async {
    List<TreeNode> list = List.generate(
      _serverData.length,
      (index) => _mapServerDataToTreeData(_serverData[index]),
    );
    return list;
  }

  /// Your server data
  final _serverData = [
    {
      "checked": true,
      "children": [
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "开发部",
        },
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "设计部",
        },
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "产品部",
        },
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "运营部",
        },
      ],
      "id": 1,
      "pid": 0,
      "show": true,
      "text": "研发部",
    },
    {
      "checked": true,
      "show": false,
      "children": [],
      "id": 2,
      "pid": 0,
      "text": "人事部",
    },
    {
      "checked": true,
      "children": [],
      "id": 3,
      "pid": 0,
      "show": false,
      "text": "销售部",
    },
  ];

  /// Map server data to tree node data
  TreeNode _mapServerDataToTreeData(Map data) {
    return TreeNode(
      extra: data,
      title: data['text'],
      expanded: data['show'],
      checked: data['checked'],
      children:
          List.from(data['children'].map((x) => _mapServerDataToTreeData(x))),
    );
  }

  //加载更多
  Future<List<TreeNode>> _loadMore(TreeNode parent) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = [
      TreeNode(
        title: '更多数据1',
        expanded: false,
        checked: true,
        children: [],
        extra: null,
      ),
      TreeNode(
        title: '更多数据2',
        expanded: false,
        checked: false,
        children: [],
        extra: null,
      ),
    ];

    return data;
  }

  Future _loadUserList() {
    _loading = true;
    return Future.delayed(const Duration(seconds: 1), () {
      _loading = false;
      return Future.value(List.generate(
          Random().nextInt(10),
          (index) => {
                'name': 'name$index',
              }).toList());
    });
  }

  Widget _buildUserListWidget(List userList) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!), color: Colors.white),
      child: ListView.builder(
        itemBuilder: (c, index) {
          return ListTile(
            title: Text(userList[index]['name']),
          );
        },
        itemCount: userList.length,
      ),
    );
  }
}
