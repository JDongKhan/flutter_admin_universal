import 'package:flutter/material.dart';

/// @author jd

///自动完成输入框，输入联想
class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField({
    Key? key,
    this.decoration = const InputDecoration(),
    this.completeList,
  }) : super(key: key);
  final InputDecoration decoration;
  final List<String>? completeList;
  @override
  State createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _focusNode.addListener(() {
      if (widget.completeList != null) {
        if (_focusNode.hasFocus) {
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context)?.insert(_overlayEntry!);
        } else {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      }
    });
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.completeList!
                  .map(
                    (e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _controller.text = e;
                        _focusNode.unfocus();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: widget.decoration,
      ),
    );
  }
}
