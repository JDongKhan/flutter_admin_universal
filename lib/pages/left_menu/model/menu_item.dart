import 'package:flutter/cupertino.dart';

/// @author jd
class MenuItem {
  final String? title;
  final IconData? iconData;
  final List<MenuItem>? items;
  final String? route;
  final WidgetBuilder? builder;
  final bool delete;
  MenuItem({
    required this.title,
    this.iconData,
    this.items,
    this.route,
    this.builder,
    this.delete = true,
  });

  Widget? _widget;

  Widget buildWidget(BuildContext context) {
    WidgetBuilder? widgetBuilder = builder;
    if (widgetBuilder != null) {
      return _widget ??= widgetBuilder.call(context);
    } else {
      return Container();
    }
  }

  MenuItem.first(this.title, this.iconData, this.items)
      : route = null,
        builder = null,
        delete = false;

  MenuItem.second(this.title, this.route, {this.builder, this.delete = true})
      : iconData = null,
        items = null;
}
