import 'package:flutter/material.dart';

/// @author jd

/// 手机端 弹出 输入框， 可以避免视图因键盘抖动
OverlayEntry? overlayEntry;

void dismissInputMessage() {
  if (overlayEntry != null) {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}

void showInputMessage({
  required BuildContext context,
  String? actionText,
  String? hintText,
}) {
  dismissInputMessage();
  overlayEntry = OverlayEntry(builder: (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.4,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  dismissInputMessage();
                },
                child: Container()),
          ),
          Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: _InputMessageWidget(
                actionText: actionText,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  });

  final OverlayState? overlay = Overlay.of(context);
  overlay?.insert(overlayEntry!);
}

class _InputMessageWidget extends StatefulWidget {
  final String? actionText;
  final String? hintText;
  const _InputMessageWidget({Key? key, this.actionText, this.hintText})
      : super(key: key);
  @override
  State createState() => _InputMessageWidgetState();
}

class _InputMessageWidgetState extends State<_InputMessageWidget> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _input(),
              ),
              SizedBox(
                width: 100,
                child: Column(
                  children: <Widget>[
                    const Icon(Icons.open_in_full_outlined),
                    if (widget.actionText != null)
                      TextButton(
                        onPressed: () {},
                        child: Text(widget.actionText!),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.insert_comment_outlined),
                  onPressed: () {
                    dismissInputMessage();
                  }),
              IconButton(
                  icon: const Icon(Icons.face_outlined), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _input() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xffEEEEEE),
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        minLines: 1,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // isDense: true,
        ),
      ),
    );
  }
}
