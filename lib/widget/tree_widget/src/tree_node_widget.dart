import 'package:flutter/material.dart';

import 'tree_node.dart';

class TreeNodeWidget extends StatefulWidget {
  final TreeNode data;
  final TreeNode parent;
  final TextStyle textStyle;
  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final double offsetLeft;

  final Function(TreeNode node) onTap;
  final void Function(bool checked, TreeNode node) onCheck;

  final void Function(TreeNode node) onExpand;
  final void Function(TreeNode node) onCollapse;

  final Future Function(TreeNode node) load;
  final void Function(TreeNode node) onLoad;

  final void Function(TreeNode node) remove;
  final void Function(TreeNode node, TreeNode parent) onRemove;

  final void Function(TreeNode node) append;
  final void Function(TreeNode node, TreeNode parent) onAppend;

  const TreeNodeWidget({
    Key? key,
    required this.data,
    required this.parent,
    required this.offsetLeft,
    required this.showCheckBox,
    required this.showActions,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
    required this.textStyle,
  }) : super(key: key);

  @override
  State createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpaned = false;
  bool _isChecked = false;
  bool _showLoading = false;
  Color _bgColor = Colors.transparent;
  late AnimationController _rotationController;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);

  List<TreeNodeWidget> _geneTreeNodes(List list) {
    return List.generate(list.length, (int index) {
      return TreeNodeWidget(
        data: list[index],
        parent: widget.data,
        remove: widget.remove,
        append: widget.append,
        icon: widget.icon,
        lazy: widget.lazy,
        load: widget.load,
        offsetLeft: widget.offsetLeft,
        showCheckBox: widget.showCheckBox,
        showActions: widget.showActions,
        onTap: widget.onTap,
        onCheck: widget.onCheck,
        onExpand: widget.onExpand,
        onLoad: widget.onLoad,
        onCollapse: widget.onCollapse,
        onRemove: widget.onRemove,
        onAppend: widget.onAppend,
        textStyle: widget.textStyle,
      );
    });
  }

  @override
  initState() {
    super.initState();
    _isExpaned = widget.data.expanded;
    _isChecked = widget.data.checked;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpand(widget.data);
        } else if (status == AnimationStatus.reverse) {
          widget.onCollapse(widget.data);
        }
      });
    if (_isExpaned) {
      _rotationController.forward();
    }
    _textEditingController.addListener(() {
      widget.data.title = _textEditingController.text;
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.data.editable = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          onHover: (event) {},
          onEnter: (event) {
            _bgColor = Colors.grey[200]!;
            setState(() {});
          },
          onExit: (event) {
            _bgColor = Colors.transparent;
            setState(() {});
          },
          child: InkWell(
            onTap: () {
              widget.onTap(widget.data);
            },
            child: Container(
              color: _bgColor,
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RotationTransition(
                    turns: _turnsTween.animate(_rotationController),
                    child: IconButton(
                      iconSize: 16,
                      icon: widget.icon,
                      onPressed: _onTapIcon,
                    ),
                  ),
                  if (widget.showCheckBox)
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        _isChecked = value!;
                        widget.onCheck(_isChecked, widget.data);
                        setState(() {});
                      },
                    ),
                  if (widget.lazy && _showLoading)
                    const SizedBox(
                      width: 12.0,
                      height: 12.0,
                      child: CircularProgressIndicator(strokeWidth: 1.0),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: _buildTitleWidget(),
                    ),
                  ),
                  if (widget.showActions)
                    TextButton(
                      onPressed: () {
                        widget.append(widget.data);
                        widget.onAppend(widget.data, widget.parent);
                      },
                      child: const Text('添加', style: TextStyle(fontSize: 12.0)),
                    ),
                  if (widget.showActions)
                    TextButton(
                      onPressed: () {
                        widget.remove(widget.data);
                        widget.onRemove(widget.data, widget.parent);
                      },
                      child: const Text('删除', style: TextStyle(fontSize: 12.0)),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: EdgeInsets.only(left: widget.offsetLeft),
            child: Column(children: _geneTreeNodes(widget.data.children)),
          ),
        )
      ],
    );
  }

  void _onTapIcon() {
    if (widget.lazy && widget.data.children.isEmpty) {
      setState(() {
        _showLoading = true;
      });
      widget.load(widget.data).then((value) {
        if (value) {
          _isExpaned = true;
          _rotationController.forward();
          widget.onLoad(widget.data);
        }
        _showLoading = false;
        setState(() {});
      });
    } else {
      _isExpaned = !_isExpaned;
      if (_isExpaned) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
      setState(() {});
    }
  }

  Widget _buildTitleWidget() {
    Widget titleWidget;
    if (widget.data.editable) {
      _textEditingController.text = widget.data.title;
      titleWidget = TextField(
        style: widget.textStyle,
        controller: _textEditingController,
        focusNode: _focusNode,
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          border: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      );
    } else {
      titleWidget = Text(
        widget.data.title,
        maxLines: 1,
        style: widget.textStyle,
        overflow: TextOverflow.ellipsis,
      );
    }
    return titleWidget;
  }
}
