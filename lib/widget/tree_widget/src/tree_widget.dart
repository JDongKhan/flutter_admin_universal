import '/widget/tree_widget/src/tree_node_widget.dart';
import 'package:flutter/material.dart';

import 'tree_node.dart';

class TreeWidget extends StatefulWidget {
  final List<TreeNode> data;

  final bool lazy;
  final Widget icon;
  final double offsetLeft;
  final bool showFilter;
  final bool showActions;
  final bool showCheckBox;
  final TextStyle textStyle;

  final Function(TreeNode node)? onTap;
  final void Function(TreeNode node)? onLoad;
  final void Function(TreeNode node)? onExpand;
  final void Function(TreeNode node)? onCollapse;
  final void Function(bool checked, TreeNode node)? onCheck;
  final void Function(TreeNode node, TreeNode parent)? onAppend;
  final void Function(TreeNode node, TreeNode parent)? onRemove;

  final TreeNode Function(TreeNode parent)? append;
  final Future<List<TreeNode>> Function(TreeNode parent)? load;

  const TreeWidget({
    Key? key,
    required this.data,
    this.onTap,
    this.onCheck,
    this.onLoad,
    this.onExpand,
    this.onCollapse,
    this.onAppend,
    this.onRemove,
    this.append,
    this.load,
    this.lazy = false,
    this.offsetLeft = 24.0,
    this.showFilter = false,
    this.showActions = false,
    this.showCheckBox = false,
    this.textStyle = const TextStyle(fontSize: 12),
    this.icon = const Icon(Icons.expand_more, size: 16.0),
  }) : super(key: key);

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  late TreeNode _root;
  List<TreeNode> _renderList = [];

  List<TreeNode> _filter(String val, List<TreeNode> list) {
    List<TreeNode> temp = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].title.contains(val)) {
        temp.add(list[i]);
      }
      if (list[i].children.isNotEmpty) {
        list[i].children = _filter(val, list[i].children);
      }
    }
    return temp;
  }

  void _onChange(String val) {
    if (val.isNotEmpty) {
      _renderList = _filter(val, _renderList);
    } else {
      _renderList = widget.data;
    }
    setState(() {});
  }

  void append(TreeNode parent) {
    parent.children.add(widget.append!(parent));
    setState(() {});
  }

  void _remove(TreeNode node, List<TreeNode> list) {
    for (int i = 0; i < list.length; i++) {
      if (node == list[i]) {
        list.removeAt(i);
      } else {
        _remove(node, list[i].children);
      }
    }
  }

  void remove(TreeNode node) {
    _remove(node, _renderList);
    setState(() {});
  }

  Future<bool> load(TreeNode node) async {
    try {
      final data = await widget.load!(node);
      node.children = data;
      setState(() {});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _renderList = widget.data;
    _root = TreeNode(
      title: '',
      extra: null,
      checked: false,
      expanded: false,
      children: _renderList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                bottom: 12.0,
              ),
              child: TextField(onChanged: _onChange),
            ),
          ...List.generate(
            _renderList.length,
            (int index) {
              return TreeNodeWidget(
                load: load,
                remove: remove,
                append: append,
                parent: _root,
                data: _renderList[index],
                icon: widget.icon,
                lazy: widget.lazy,
                textStyle: widget.textStyle,
                offsetLeft: widget.offsetLeft,
                showCheckBox: widget.showCheckBox,
                showActions: widget.showActions,
                onTap: widget.onTap ?? (n) {},
                onLoad: widget.onLoad ?? (n) {},
                onCheck: widget.onCheck ?? (b, n) {},
                onExpand: widget.onExpand ?? (n) {},
                onRemove: widget.onRemove ?? (n, p) {},
                onAppend: widget.onAppend ?? (n, p) {},
                onCollapse: widget.onCollapse ?? (n) {},
              );
            },
          )
        ],
      ),
    );
  }
}
