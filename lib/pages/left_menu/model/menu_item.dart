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

  const MenuItem.first(
      String this.title, IconData this.iconData, List<MenuItem> this.items)
      : route = null,
        builder = null;

  const MenuItem.second(String this.title, String this.route, {this.builder})
      : iconData = null,
        items = null;
}
