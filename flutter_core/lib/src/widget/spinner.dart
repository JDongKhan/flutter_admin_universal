import 'package:flutter/material.dart';

/// @author jd

///自定义下拉菜单，如意见反馈模块
class Spinner<T> extends StatefulWidget {
  Spinner({
    Key? key,
    required this.items,
    this.title,
    this.style,
    this.onChanged,
    this.dropdownColor,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  final List<SpinnerItem<T>> items;
  final ValueChanged<T>? onChanged;
  final TextStyle? style;
  final T? title;
  final Color? dropdownColor;
  final InputDecoration? decoration;

  @override
  State<Spinner<T>> createState() => _SpinnerState<T>();
}

class _SpinnerState<T> extends State<Spinner<T>> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  SpinnerItem<T>? _currentItem;
  SpinnerItem<T>? get currentItem => _currentItem;

  set currentItem(item) {
    _currentItem = item;
    _textEditingController.text = item.title ?? '';
    widget.onChanged?.call(item.value);
  }

  OverlayEntry? _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  void _show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            color: widget.dropdownColor ?? Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue[100]!),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2.0, 3.0), //阴影xy轴偏移量
                    blurRadius: 5.0, //阴影模糊程度
                    spreadRadius: 1.0, //阴影扩散程度
                  ),
                ],
              ),
              child: Column(
                children: widget.items
                    .map(
                      (e) => ListTile(
                        key: e.key,
                        title: e.child ?? Text(e.title!),
                        onTap: () {
                          _dismiss();
                          currentItem = e;
                          e.onTap?.call();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    _textEditingController.text = '${widget.title ?? widget.items.first.title}';
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _dismiss();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          TextField(
            readOnly: true,
            focusNode: _focusNode,
            decoration: widget.decoration,
            controller: _textEditingController,
            textAlign: TextAlign.left,
            style: widget.style,
            onTap: () {
              _show(context);
            },
          ),
          Positioned(
            right: 0,
            child: ExpandIcon(
              isExpanded: _overlayEntry != null,
              onPressed: (bool value) {},
            ),
          ),
        ],
      ),
    );
  }
}

class SpinnerItem<T> {
  SpinnerItem({
    this.key,
    this.onTap,
    required this.value,
    this.title,
    this.enabled = true,
    this.alignment = Alignment.centerLeft,
    this.child,
  }) : assert(title != null || child != null);

  final Key? key;
  final AlignmentGeometry alignment;
  final VoidCallback? onTap;
  final String? title;
  final T value;
  final bool enabled;
  final Widget? child;
}
