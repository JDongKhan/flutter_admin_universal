import 'package:flutter/material.dart';

void showCommonDialog(
    {required BuildContext context, required WidgetBuilder builder}) {
  showDialog(
    context: context,
    builder: (c) {
      return Dialog(
        clipBehavior: Clip.hardEdge,
        child: builder(c),
      );
    },
  );
}

Widget buildFormTextField(
  String label,
  IconData icon, {
  TextEditingController? controller,
  bool obscureText = false,
  FocusNode? focusNode,
  bool notEmpty = false,
  EdgeInsetsGeometry margin = const EdgeInsets.only(top: 20),
}) {
  return Container(
    margin: margin,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: TextFormField(
      style: const TextStyle(color: Colors.black, fontSize: 14),
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      maxLines: 1,
      scrollPadding: const EdgeInsets.all(0),
      validator: (value) {
        if (notEmpty) {
          if (value == null || value == '') {
            return '$label 不能为空';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.only(
            right: 10, left: 10, top: 12, bottom: 12), //这里是关键
        border: const OutlineInputBorder(),
        labelText: label,
        icon: Icon(
          icon,
          size: 18,
          color: Colors.black54,
        ),
      ),
      onSaved: (v) {},
      onFieldSubmitted: (v) {},
    ),
  );
}
