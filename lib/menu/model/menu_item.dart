import 'package:flutter/cupertino.dart';

/// @author jd
class MenuItem {
  final String title;
  final IconData iconData;
  final List<MenuItem> items;
  final String route;
  const MenuItem({
    @required this.title,
    this.iconData,
    this.items,
    this.route,
  });

  const MenuItem.first(String title, IconData iconData, List<MenuItem> items)
      : title = title,
        iconData = iconData,
        items = items,
        route = null;

  const MenuItem.second(String title, String route)
      : title = title,
        iconData = null,
        items = null,
        route = route;
}
