import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

///下拉菜单
enum DropDownMenuPosition {
  top,
  bottom,
  // left,
  // right,
}

typedef CustomTransitionsBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

Widget customSlideTransitionBuilder(
    BuildContext context, Animation<double> animation, Widget child) {
  Animation<double> a = Tween(begin: 0.0, end: 1.0).animate(animation);
  return SizeTransition(
    sizeFactor: a,
    child: child,
  );
}

///下拉菜单控制器
class DropDownMenuController extends ChangeNotifier {
  DropDownMenuController({String? text}) : _text = text;

  bool _showMenu = false;

  String? _text;

  String? _value;

  ///显示菜单
  void show() {
    if (_showMenu == false) {
      _showMenu = true;
      notifyListeners();
    }
  }

  ///关闭菜单
  void dismiss() {
    if (_showMenu == true) {
      _showMenu = false;
      notifyListeners();
    }
  }

  ///显示（关闭）菜单
  void showOrDismiss() {
    _showMenu = !_showMenu;
    notifyListeners();
  }

  ///选中的文本
  set text(value) {
    if (_text != value) {
      _text = value;
      notifyListeners();
    }
  }

  get text => _text;

  ///选中的值
  set value(v) {
    _value = v;
  }

  get value => _value;
}

///下拉菜单框架
class DropDownMenu extends StatefulWidget {
  const DropDownMenu({
    Key? key,
    required this.child,
    required this.menuWidget,
    required this.controller,
  }) : super(key: key);

  ///菜单下发的业务widget
  final Widget child;

  ///菜单widget
  final Widget menuWidget;

  ///控制器
  final DropDownMenuController controller;

  @override
  State createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  void initState() {
    widget.controller.addListener(_refreshUI);
    super.initState();
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refreshUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.child,
        ),
        if (widget.controller._showMenu)
          Positioned.fill(child: widget.menuWidget),
      ],
    );
  }
}

// ignore: must_be_immutable
///下（上）拉菜单按钮
class DropdownButton extends StatefulWidget {
  const DropdownButton({
    Key? key,
    this.style,
    this.isDense = false,
    this.textConstriants = const BoxConstraints(maxWidth: 100),
    this.firstIcon = const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 18,
    ),
    this.secondIcon = const Icon(
      Icons.keyboard_arrow_up_rounded,
      size: 18,
    ),
    required this.controller,
  })  : assert(isDense == false || textConstriants != null, '设置紧约束时需要给文本添加约束'),
        super(key: key);

  ///文案样式
  final TextStyle? style;

  ///是否紧凑
  final bool isDense;

  ///文案的约束
  final BoxConstraints textConstriants;

  ///控制器
  final DropDownMenuController controller;

  ///文案后面的切换小图标
  final Icon firstIcon;
  final Icon secondIcon;

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState<T> extends State<DropdownButton> {
  @override
  void initState() {
    widget.controller.addListener(_refreshUI);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refreshUI);
    super.dispose();
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void _click(BuildContext context) {
    widget.controller.showOrDismiss();
  }

  @override
  Widget build(BuildContext context) {
    Text textWidget = Text(
      widget.controller.text ?? '',
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: widget.style,
    );

    return GestureDetector(
      onTap: () {
        _click(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isDense
              ? Container(
                  constraints: widget.textConstriants,
                  child: textWidget,
                )
              : Expanded(
                  child: Container(
                    child: textWidget,
                  ),
                ),
          widget.controller._showMenu ? widget.secondIcon : widget.firstIcon,
        ],
      ),
    );
  }
}

///菜单内容
class DropDownMenuContentWidget extends StatefulWidget {
  const DropDownMenuContentWidget({
    Key? key,
    required this.builder,
    required this.controller,
    this.offset,
    this.position = DropDownMenuPosition.top,
    this.transitionsBuilder = customSlideTransitionBuilder,
  }) : super(key: key);

  ///创建菜单的回调
  final WidgetBuilder builder;

  ///控制器
  final DropDownMenuController controller;

  ///菜单所在位置
  final DropDownMenuPosition position;

  ///菜单的偏移量
  final double? offset;

  ///动画
  final CustomTransitionsBuilder transitionsBuilder;

  @override
  State<DropDownMenuContentWidget> createState() =>
      _DropDownMenuContentWidgetState();
}

class _DropDownMenuContentWidgetState extends State<DropDownMenuContentWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animationController?.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    Widget tapWidget = Expanded(
      child: GestureDetector(
        onTap: () {
          widget.controller.dismiss();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );

    Widget menuChild = widget.builder(context);
    Widget menuWidget = widget.transitionsBuilder != null
        ? widget.transitionsBuilder(context, _animationController!, menuChild)
        : menuChild;

    EdgeInsets? margin;

    if (widget.position == DropDownMenuPosition.top) {
      margin = EdgeInsets.only(top: widget.offset ?? 0);
      children.add(menuWidget);
      children.add(tapWidget);
    } else if (widget.position == DropDownMenuPosition.bottom) {
      margin = EdgeInsets.only(bottom: widget.offset ?? 0);
      children.add(tapWidget);
      children.add(menuWidget);
    }

    return Container(
      margin: margin,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withAlpha(150),
          ),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}
