import 'package:flutter/cupertino.dart';

/// @author jd
class MenuItem {
  final String? title;
  final IconData? iconData;
  final List<MenuItem>? items;
  final String? route;
  final WidgetBuilder? builder;
  const MenuItem({
    required this.title,
    this.iconData,
    this.items,
    this.route,
    this.builder,
  });

  const MenuItem.first(String title, IconData iconData, List<MenuItem> items)
      : title = title,
        iconData = iconData,
        items = items,
        route = null,
        builder = null;

  const MenuItem.second(String title, String route, {WidgetBuilder? builder})
      : title = title,
        iconData = null,
        items = null,
        builder = builder,
        route = route;
}
