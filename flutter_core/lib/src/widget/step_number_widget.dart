import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// @author jd
/// + - 输入编辑框
class StepNumberWidget extends StatefulWidget {
  const StepNumberWidget({
    Key? key,
    this.height = 30,
    this.width = 40,
    this.iconWidth = 40,
    this.value = 0,
    this.min = 0,
    this.max = 99999,
    this.onChanged,
  }) : super(key: key);
  final int max;
  final int min;
  final double height;
  final double width;
  final double iconWidth;
  final int value;
  final ValueChanged? onChanged;

  @override
  _StepNumberWidgetState createState() => _StepNumberWidgetState();
}

class _StepNumberWidgetState extends State<StepNumberWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  int value = 0;
  @override
  void initState() {
    super.initState();
    value = widget.value;
    _textEditingController.text = widget.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _reduceIconButton(),
          Container(
            width: widget.width,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 1, color: Colors.black12),
                right: BorderSide(width: 1, color: Colors.black12),
              ),
            ),
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
              ],
              controller: _textEditingController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
              enableInteractiveSelection: false,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 0, top: 2, bottom: 2, right: 0),
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          _addIconButton(),
        ],
      ),
    );
  }

  Widget _reduceIconButton() {
    VoidCallback? click;
    if (value > widget.min) {
      click = _reduceClick;
    }
    return Container(
      width: widget.width,
      alignment: Alignment.center,
      child: IconButton(
        // enableFeedback: false,
        iconSize: 20,
        padding: const EdgeInsets.all(0.0),
        icon: const Icon(Icons.remove),
        onPressed: click,
      ),
    );
  }

  Widget _addIconButton() {
    VoidCallback? click;
    if (value < widget.max) {
      click = _addClick;
    }
    return Container(
      width: widget.width,
      alignment: Alignment.center,
      child: IconButton(
        // enableFeedback: false,
        iconSize: 20,
        padding: const EdgeInsets.all(0.0),
        icon: const Icon(Icons.add),
        onPressed: click,
      ),
    );
  }

  void _addClick() {
    int num = int.parse(_textEditingController.text);
    num++;
    if (num > widget.max) {
      num = widget.max;
    }
    value = num;
    _textEditingController.text = num.toString();
    widget.onChanged?.call(num);
    setState(() {});
  }

  void _reduceClick() {
    int num = int.parse(_textEditingController.text);
    num--;
    if (num < widget.min) {
      num = widget.min;
    }
    value = num;
    _textEditingController.text = num.toString();
    widget.onChanged?.call(num);
    setState(() {});
  }
}
