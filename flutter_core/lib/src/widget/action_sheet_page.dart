import 'package:flutter/material.dart';

///@Description TODO
///@Author jd
///

// CarBottomExpandedIcon(
//   onExpanded: () {
//     return Navigator.of(context).push(NoAnimRouter(
//       child: CustomActionSheetPage(
//         context: context,
//         child: ShopCarDetailWidget(
//           entity: entity,
//         ),
//       ),
//     ));
//   },
//   title: '明细',
//   titleStyle: const TextStyle(
//     color: Color(0xFFEB2121),
//     fontSize: 12,
//   ),
// ),

//跟showModalBottomSheet的区别是针对widget的弹框，该widget下面的全部漏出，而showModalBottomSheet是一个全屏的
typedef CustomActionSheetTransitionsBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

Widget kCustomSlideTransitionBuilder(
    BuildContext context, Animation<double> animation, Widget child) {
  Animation<double> a = Tween(begin: 0.0, end: 1.0).animate(animation);
  return SizeTransition(
    sizeFactor: a,
    child: child,
  );
}

class CustomActionSheetPage extends StatefulWidget {
  const CustomActionSheetPage({
    Key? key,
    required this.context,
    required this.child,
    this.offset,
    this.transitionsBuilder = kCustomSlideTransitionBuilder,
  }) : super(key: key);

  final BuildContext context;

  ///偏移
  final Offset? offset;

  ///子页面
  final Widget child;
  final CustomActionSheetTransitionsBuilder transitionsBuilder;

  @override
  State<CustomActionSheetPage> createState() => _CustomActionSheetPageState();
}

class _CustomActionSheetPageState extends State<CustomActionSheetPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dy = 0;
    RenderBox renderBox = widget.context.findRenderObject() as RenderBox;
    Rect position = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    dy = MediaQuery.of(context).size.height - position.top;
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0x80000000),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  widget.transitionsBuilder != null
                      ? widget.transitionsBuilder(
                          context, _animationController!, widget.child)
                      : widget.child,
                ],
              ),
            ),
          ),
          Container(
            height: widget.offset?.dy ?? dy,
          ),
        ],
      ),
    );
  }
}
