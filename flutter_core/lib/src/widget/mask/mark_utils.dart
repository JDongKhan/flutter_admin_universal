import 'package:flutter/material.dart';

import 'mask_widget.dart';

///
///  @override
//   void initState() {
//     super.initState();
//
//     ///显示蒙版提示
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       MarkUtils.showMark(context, [
//         MarkEntry(
//           widget: BubbleWidget(
//             child: const Text(
//               '标题',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           left: 100,
//           top: 80,
//         ),
//         MarkEntry(
//           widget: BubbleWidget(
//             position: BubbleArrowDirection.right,
//             child: const Text(
//               '内容',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           left: 100,
//           top: 100,
//         ),
//         MarkEntry(
//           widget: BubbleWidget(
//             position: BubbleArrowDirection.left,
//             child: const Text(
//               '列表',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           left: 10,
//           top: 200,
//         ),
//       ]);
//     });
//   }

class MarkUtils {
  static void showMark(BuildContext context, List<MarkEntry> entryList) {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return MarkWidget(
          entryList: entryList,
        );
      },
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }
}
